//
//  PopulationViewModel.swift
//  PopulationApp
//
//  Created by Muhammad Umair on 24/01/1446 AH.

import Foundation
import Combine

class PopulationViewModel: ObservableObject {
    @Published var populationData: [PopulationData] = [] {
        didSet {
            filterData()
        }
    }
    
    @Published var filteredData: [PopulationData] = []
    @Published var selectedSegment: Segment = .state
    
    private let networkManager: NetworkManagerProtocol
    private var cancellables: Set<AnyCancellable> = []

    var onUpdate: (() -> Void)?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        let group = DispatchGroup()

        var stateData: [PopulationData] = []
        var nationData: [PopulationData] = []

        group.enter()
        networkManager.fetchStatePopulationData { result in
            switch result {
            case .success(let data):
                stateData = data
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }

        group.enter()
        networkManager.fetchNationPopulationData { result in
            switch result {
            case .success(let data):
                nationData = data
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            self?.populationData = stateData + nationData
            self?.filterData()
        }
    }


    func filterData() {
        switch selectedSegment {
        case .state:
            filteredData = populationData.filter { $0.regionType == .state }
        case .nation:
            filteredData = populationData.filter { $0.regionType == .nation }
        }
    }
    
    enum Segment {
        case state
        case nation
    }


}
