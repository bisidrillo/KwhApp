//
//  ContentViewModel.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 27/6/24.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var statusMessage: String = "Conectando a la API..."
    @Published var electricityPrices: [ElectricityPrice] = []

    init() {
        fetchElectricityPrice()
    }

    func fetchElectricityPrice() {
        ApiService.fetchElectricityPrice { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let prices):
                self.electricityPrices = prices
                self.statusMessage = "Datos cargados correctamente."
            case .failure(let error):
                self.statusMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
}
