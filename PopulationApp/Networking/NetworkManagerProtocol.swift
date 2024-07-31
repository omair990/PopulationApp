//
//  NetworkManagerProtocol.swift
//  PopulationApp
//
//  Created by Muhammad Umair on 24/01/1446 AH.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchStatePopulationData(completion: @escaping (Result<[PopulationData], Error>) -> Void)
    func fetchNationPopulationData(completion: @escaping (Result<[PopulationData], Error>) -> Void)
}
