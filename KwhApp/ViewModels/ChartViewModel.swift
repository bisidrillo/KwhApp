//
//  ChartViewModel.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 27/6/24.
//

import Foundation

class ChartViewModel: ObservableObject {
    @Published var statusMessage: String = "Conectando a la API..."
    @Published var electricityPrices: [ChartData] = []
    @Published var selectedTimeRange: TimeRange = .day

    init() {
        fetchElectricityPrice()
    }

    func fetchElectricityPrice() {
        ApiService.fetchElectricityPrice { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let prices):
                self.electricityPrices = prices.map {
                    ChartData(hour: $0.hour, price: $0.pricePerKWh)
                }
                self.statusMessage = "Datos cargados correctamente"
            case .failure(let error):
                self.statusMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
}
