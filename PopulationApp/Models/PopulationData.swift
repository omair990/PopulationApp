//
//  PopulationData.swift
//  PopulationApp
//
//  Created by Muhammad Umair on 24/01/1446 AH.
//

import Foundation

enum RegionType: String, Codable {
    case state = "State"
    case nation = "Nation"
}

struct PopulationData: Codable, Identifiable {
    let id = UUID()
    let regionName: String
    let population: Int
    let idRegion: String
    var year: Int
    let slugRegion: String
    var regionType: RegionType?

    enum CodingKeys: String, CodingKey {
        case state = "State"
        case nation = "Nation"
        case population = "Population"
        case idState = "ID State"
        case idNation = "ID Nation"
        case year = "Year"
        case slugState = "Slug State"
        case slugNation = "Slug Nation"
    }

    // Custom initializer for testing purposes
    init(regionName: String, population: Int, idRegion: String, year: Int, slugRegion: String, regionType: RegionType?) {
        self.regionName = regionName
        self.population = population
        self.idRegion = idRegion
        self.year = year
        self.slugRegion = slugRegion
        self.regionType = regionType
    }

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let state = try? container.decode(String.self, forKey: .state) {
            self.regionName = state
            self.regionType = .state
            self.idRegion = try container.decode(String.self, forKey: .idState)
            self.slugRegion = try container.decode(String.self, forKey: .slugState)
        } else if let nation = try? container.decode(String.self, forKey: .nation) {
            self.regionName = nation
            self.regionType = .nation
            self.idRegion = try container.decode(String.self, forKey: .idNation)
            self.slugRegion = try container.decode(String.self, forKey: .slugNation)
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.state, in: container, debugDescription: "Region name is missing")
        }
        self.population = try container.decode(Int.self, forKey: .population)
        
        if let yearString = try? container.decode(String.self, forKey: .year),
           let yearInt = Int(yearString) {
            self.year = yearInt
        } else {
            self.year = try container.decode(Int.self, forKey: .year)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let regionType = regionType {
            switch regionType {
            case .state:
                try container.encode(regionName, forKey: .state)
                try container.encode(idRegion, forKey: .idState)
                try container.encode(slugRegion, forKey: .slugState)
            case .nation:
                try container.encode(regionName, forKey: .nation)
                try container.encode(idRegion, forKey: .idNation)
                try container.encode(slugRegion, forKey: .slugNation)
            }
        }
        try container.encode(population, forKey: .population)
        try container.encode(String(year), forKey: .year)
    }
}


struct PopulationResponse: Codable {
    let data: [PopulationData]
}
