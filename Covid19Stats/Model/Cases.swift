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
    var continent: String
    var abbreviation: String
    var location: String
    var capital_city: String
    var updated: String?
    
    var confirmedPercent: String {
        get {
            let percent = Double(confirmed) / Double(population) * 100
            return String(format: "%.2f", percent) + "%"
        }
    }
    
    var deathsPercent: String {
        get {
            let percent = Double(deaths) / Double(confirmed) * 100
            return String(format: "%.2f", percent) + "%"
        }
    }
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
