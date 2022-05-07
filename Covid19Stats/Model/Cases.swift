//
//  Cases.swift
//  Covid19Stats
//
//  Created by andrey perevedniuk on 03.05.2022.
//

import Foundation

struct Cases: Decodable {
    var All: Case
}

struct Case: Decodable {
    var confirmed: UInt
    var recovered: UInt
    var deaths: UInt
    var country: String
    var population: UInt
    var sq_km_area: UInt
    var life_expectancy: String
    var elevation_in_meters: UInt
    var continent: String
    var abbreviation: String
    var location: String
    var iso: Int
    var capital_city: String
    var lat: String
    var long: String
    var updated: String
}

extension UInt {
    
    func toGroupingSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true;
        formatter.groupingSeparator = " "
        
        return formatter.string(for: self) ?? String(self);
    }
}
