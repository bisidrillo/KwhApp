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
    @Published var currentDate: String = "" // Añadir la propiedad currentDate

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Inicializar currentDate con la fecha actual
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        currentDate = dateFormatter.string(from: Date())
    }

    func fetchElectricityPrice() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: currentDate) else {
            statusMessage = "Fecha inválida"
            return
        }
        ApiService.fetchElectricityPrice(for: date) { [weak self] (result: Result<[ElectricityPrice], Error>) in
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
