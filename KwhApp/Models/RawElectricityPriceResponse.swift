//
//  RawElectricityPriceResponse.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 28/6/24.
//

import Foundation

struct RawElectricityPriceResponse: Codable {
    let data: DataClass
    let included: [Included]
    
    struct DataClass: Codable {
        let type: String
        let id: String
        let attributes: DataAttributes
        let meta: Meta
    }

    struct DataAttributes: Codable {
        let title: String
        let lastUpdate: String
        let description: String?
        
        enum CodingKeys: String, CodingKey {
            case title
            case lastUpdate = "last-update"
            case description
        }
    }

    struct Meta: Codable {
        let cacheControl: CacheControl
        
        enum CodingKeys: String, CodingKey {
            case cacheControl = "cache-control"
        }
    }

    struct CacheControl: Codable {
        let cache: String
    }

    struct Included: Codable {
        let type: String
        let id: String
        let attributes: IncludedAttributes
    }

    struct IncludedAttributes: Codable {
        let title: String
        let description: String?
        let color: String
        let type: String?
        let magnitude: String
        let composite: Bool
        let lastUpdate: String
        let values: [Value]
        
        enum CodingKeys: String, CodingKey {
            case title
            case description
            case color
            case type
            case magnitude
            case composite
            case lastUpdate = "last-update"
            case values
        }
    }

    struct Value: Codable {
        let value: Double
        let percentage: Int
        let datetime: String
    }
}
