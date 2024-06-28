//
//  ApiService.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 27/6/24.
//

import Foundation

class ApiService {
    static func fetchElectricityPrice(completion: @escaping (Result<[ElectricityPrice], Error>) -> Void) {
        guard let url = URL(string: "https://apidatos.ree.es/es/datos/mercados/precios-mercados-tiempo-real?start_date=2024-06-28T00:00&end_date=2024-06-28T23:59&time_trunc=hour&geo_limit=ccaa&geo_ids=8742") else {
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
                                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                                        let rawResponse = try decoder.decode(RawElectricityPriceResponse.self, from: data)
                                        guard let included = rawResponse.included.first else {
                                            completion(.failure(NSError(domain: "No data included", code: -1, userInfo: nil)))
                                            return
                                        }
                                        let pricesResponse = included.attributes.values.map {
                                            ElectricityPrice(date: $0.datetime, pricePerKWh: $0.value / 1000, color: included.attributes.color) // Asigna el color
                                        }
                    print(pricesResponse) // Agrega esto para depurar los precios y colores
                                        completion(.success(pricesResponse))
                                    } catch {
                                        completion(.failure(error))
                                    }
                                }
                            }
                            task.resume()
    }
}
