//
//  MockNetworkManager.swift
//  PopulationApp
//
//  Created by Muhammad Umair on 24/01/1446 AH.
//
import Foundation
import Combine
@testable import PopulationApp

class MockNetworkManager: NetworkManagerProtocol {
    var mockStateResult: Result<[PopulationData], Error>?
    var mockNationResult: Result<[PopulationData], Error>?

    func fetchStatePopulationData(completion: @escaping (Result<[PopulationData], Error>) -> Void) {
        if let result = mockStateResult {
            completion(result)
        } else {
            fatalError("Mock result for state population data not set.")
        }
    }

    func fetchNationPopulationData(completion: @escaping (Result<[PopulationData], Error>) -> Void) {
        if let result = mockNationResult {
            completion(result)
        } else {
            fatalError("Mock result for nation population data not set.")
        }
    }
}
