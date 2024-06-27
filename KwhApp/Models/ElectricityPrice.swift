//
//  ElectricityPrice.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 27/6/24.
//

import Foundation

struct ElectricityPrice: Codable, Identifiable {
    var id: String { date + hour }
    let date: String
    var hour: String
    let isCheap: Bool
    let isUnderAvg: Bool
    let market: String
    let price: Double
    let units: String
    
    private enum CodingKeys: String, CodingKey {
        case date, hour, market, price, units
        case isCheap = "is-cheap"
        case isUnderAvg = "is-under-avg"
    }
    
    var pricePerKWh: Double {
        return price / 1000
    }
    
    var priceLevel: String {
        if pricePerKWh < 0.1 {
            return "cheap"
        } else if pricePerKWh < 0.2 {
            return "medium"
        } else {
            return "expensive"
        }
    }
}
