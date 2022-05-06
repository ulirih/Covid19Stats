//
//  CovidService.swift
//  Covid19Stats
//
//  Created by andrey perevedniuk on 03.05.2022.
//

import Foundation
import UIKit

class CovidService {
    
    private let baseUrl = "https://covid-api.mmediagroup.fr/v1/"
    
    func getCommonCases(countryCode: String, completion: @escaping(_ result: Case?, _ error: String?) -> Void) {
        let urlString = "\(baseUrl)cases?ab=\(countryCode)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            if error != nil {
                completion(nil, error?.localizedDescription)
                return
            }
            
            guard let jsonData = data else {
                completion(nil, "No data error")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(Cases.self, from: jsonData)
                completion(result.All, nil)
                
            } catch {
                completion(nil, "Perse data error: \(url.absoluteURL)")
            }
        }.resume()
    }
}
