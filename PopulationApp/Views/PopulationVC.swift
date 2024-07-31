//
//  PopulationVC.swift
//  PopulationApp
//
//  Created by Muhammad Umair on 24/01/1446 AH.
//

import UIKit
import Combine

class PopulationVC: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var populationTableView: UITableView!
    
    private var viewModel = PopulationViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        setupTableView()
        setupBindings()
    }
    
    private func setupSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }
  
    private func setupTableView() {
        populationTableView.register(PopulationTableViewCell.self, forCellReuseIdentifier: "PopulationCell")
        populationTableView.dataSource = self
        populationTableView.delegate = self
        populationTableView.rowHeight = UITableView.automaticDimension
        populationTableView.estimatedRowHeight = 140
    }
    
    private func setupBindings() {
        viewModel.$filteredData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.populationTableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$selectedSegment
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.filterData()
            }
            .store(in: &cancellables)
    }
    
    @objc private func segmentedControlChanged() {
        viewModel.selectedSegment = segmentedControl.selectedSegmentIndex == 0 ? .state : .nation
    }
}

extension PopulationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PopulationCell", for: indexPath) as? PopulationTableViewCell else {
            return UITableViewCell()
        }
        let data = viewModel.filteredData[indexPath.row]
        cell.configure(with: data)
        cell.delegate = self
        
        print(data)
        
        
        return cell
    }
}

extension PopulationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PopulationVC: PopulationTableViewCellDelegate {
    func didTapDetailButton(for region: PopulationData) {
        let message = """
        ID: \(region.idRegion)
        Name: \(region.regionName)
        Population: \(region.population)
        Year: \(region.year)
        Slug: \(region.slugRegion)
        """
        let alert = UIAlertController(title: "Region Details", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
