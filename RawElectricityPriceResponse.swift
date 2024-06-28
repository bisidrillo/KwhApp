//
//  RawElectricityPriceResponse.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 28/6/24.
//

import Foundation

struct RawElectricityPriceResponse: Codable {
    let include: [Included]
    struct Included: Codable {
        let attributes: Attributes
    }
    struct Attributes: Codable {
        let values: [Value]
        
    }
    struct Value: Codable {
        let value: Double
        let datetime: String
        
    }
}
