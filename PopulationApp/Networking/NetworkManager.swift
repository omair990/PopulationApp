//
//  NetworkManager.swift
//  PopulationApp
//
//  Created by Muhammad Umair on 24/01/1446 AH.
//
import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(DecodingError)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .noData:
            return "No data was received from the server."
        case .decodingError(let decodingError):
            return "Failed to decode data: \(decodingError.localizedDescription)"
        }
    }
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    func fetchStatePopulationData(completion: @escaping (Result<[PopulationData], Error>) -> Void) {
        fetchPopulationData(urlString: "https://datausa.io/api/data?drilldowns=State&measures=Population&year=latest", regionType: .state, completion: completion)
    }

    func fetchNationPopulationData(completion: @escaping (Result<[PopulationData], Error>) -> Void) {
        fetchPopulationData(urlString: "https://datausa.io/api/data?drilldowns=Nation&measures=Population", regionType: .nation, completion: completion)
    }
    
    private func fetchPopulationData(urlString: String, regionType: RegionType, completion: @escaping (Result<[PopulationData], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        print(url)

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let populationResponse = try JSONDecoder().decode(PopulationResponse.self, from: data)
                var modifiedData = populationResponse.data
                for i in 0..<modifiedData.count {
                    modifiedData[i].regionType = regionType
                }
                
                print(modifiedData)
                
                completion(.success(modifiedData))
                
                
                
            } catch let decodingError as DecodingError {
                completion(.failure(NetworkError.decodingError(decodingError)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
