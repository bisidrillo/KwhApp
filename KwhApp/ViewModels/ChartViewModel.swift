//
//  ChartViewModel.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 27/6/24.
//

import Foundation
import Combine

class ChartViewModel: ObservableObject {
    @Published var statusMessage: String = "Conectando a la API..."
    @Published var electricityPrices: [ElectricityPrice] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    
    func fetchElectricityPrice() {
        ApiService.fetchElectricityPrice { [weak self] result in
            switch result {
            case .success(let prices):
                self?.electricityPrices = prices
                self?.statusMessage = "Datos cargados correctamente"
            case .failure(let error):
                self?.statusMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
    
}
