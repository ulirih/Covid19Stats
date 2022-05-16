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

    func getCommonCases(countryCode: String, completion: @escaping(Result<Cases, Error>) -> Void) {
        
        let urlString = "\(baseUrl)cases?ab=\(countryCode)"
        guard let url = URL(string: urlString) else { return }
        
        baseConutryRequest(url: url, completion: completion)
    }
    
    func getVaccinesInfo(countryCode: String, completion: @escaping(Result<Vaccines, Error>) -> Void) {
        
        let urlString = "\(baseUrl)vaccines?ab=\(countryCode)"
        guard let url = URL(string: urlString) else { return }
        
        baseConutryRequest(url: url, completion: completion)
    }
    
    private func baseConutryRequest<T: Decodable>(url: URL, completion: @escaping(Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, responce, error in
            var result: Result<T, Error>
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
                let _data = try JSONDecoder().decode(T.self, from: jsonData)
                result = .success(_data)
                
            } catch {
                result = .failure(CovidServiceError.parseError)
            }
        }.resume()
    }
}
