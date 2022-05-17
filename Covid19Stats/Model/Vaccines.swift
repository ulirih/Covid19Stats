//
//  Vaccines.swift
//  Covid19Stats
//
//  Created by andrey perevedniuk on 16.05.2022.
//

import Foundation

struct Vaccines: Decodable {
    var All: Vaccine
}

struct Vaccine: Decodable {
    var administered: UInt
    var people_vaccinated: UInt
    var people_partially_vaccinated: UInt
    var country: String
    var population: UInt
    var life_expectancy: String
    var updated: String
    
    var vaccinatedPerceent: String {
        get {
            let percent = Double(people_vaccinated) / Double(population) * 100
            return String(format: "%.2f", percent) + "%"
        }
    }
}
