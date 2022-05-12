//
//  CovidService.swift
//  Covid19Stats
//
//  Created by andrey perevedniuk on 03.05.2022.
//

import Foundation
import UIKit

enum CovidServiceError: Error {
    case noDataError
    case parseError
}

class CovidService {
    
    private let baseUrl = "https://covid-api.mmediagroup.fr/v1/"

    func getCommonCases(countryCode: String, completion: @escaping(Result<Case, Error>) -> Void) {
        
        let urlString = "\(baseUrl)cases?ab=\(countryCode)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            var result: Result<Case, Error>
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if let error = error {
                result = .failure(error)
                return
            }
            
            guard let jsonData = data else {
                result = .failure(CovidServiceError.noDataError)
                return
            }
            
            do {
                let cases = try JSONDecoder().decode(Cases.self, from: jsonData)
                result = .success(cases.All)
                
            } catch {
                result = .failure(CovidServiceError.parseError)
            }
        }.resume()
    }
}
