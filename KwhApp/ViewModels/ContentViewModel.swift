//
//  ContentViewModel.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 27/6/24.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var electricityPrices: [ElectricityPrice] = []
    @Published var statusMessage: String = "Conectando a la API..."
    @Published var currentDate: String = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        currentDate = dateFormatter.string(from: Date())
    }

    func fetchElectricityPrice() {
        ApiService.fetchElectricityPrice { [weak self] result in
            switch result {
            case .success(let prices):
                self?.electricityPrices = prices
                self?.statusMessage = "Datos cargados correctamente."
            case .failure(let error):
                self?.statusMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
}
