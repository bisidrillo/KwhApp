import Foundation

class ApiService {
    static func fetchElectricityPrice(for date: Date, completion: @escaping (Result<[ElectricityPrice], Error>) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        let urlString = "https://apidatos.ree.es/es/datos/mercados/precios-mercados-tiempo-real?start_date=\(formattedDate)T00:00&end_date=\(formattedDate)T23:59&time_trunc=hour&geo_limit=ccaa&geo_ids=8742"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URL no válida", code: -1, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No se recibieron datos", code: -1, userInfo: nil)))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let rawResponse = try decoder.decode(RawElectricityPriceResponse.self, from: data)
                    guard let included = rawResponse.included.first else {
                        completion(.failure(NSError(domain: "No data included", code: -1, userInfo: nil)))
                        return
                    }
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                    let pricesResponse = included.attributes.values.compactMap { value -> ElectricityPrice? in
                        guard let date = dateFormatter.date(from: value.datetime) else { return nil }
                        return ElectricityPrice(date: value.datetime, pricePerKWh: value.value / 1000, timestamp: date, color: included.attributes.color)
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
