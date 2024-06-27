//
//  ApiService.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 27/6/24.
//

import Foundation


class ApiService {
    
    static func fetchElectricityPrice(completion: @escaping (Result<[ElectricityPrice], Error>) -> Void) {
        guard let url = URL(string: "https://api.preciodelaluz.org/v1/prices/all?zone=PCB") else {
            completion(.failure(NSError(domain: "URL no válida", code: -1, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                    let statusError = NSError(domain: "Respuesta inválida", code: -1, userInfo: nil)
                    completion(.failure(statusError))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let rawResponse = try decoder.decode([String: ElectricityPrice].self, from: data)
                    let pricesResponse = rawResponse.map { (key, value) -> ElectricityPrice in
                        var updatedValue = value
                        updatedValue.hour = key
                        return updatedValue
                    }
                    completion(.success(pricesResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
