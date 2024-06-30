//
//  ContentViewModel.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 27/6/24.
//

import Foundation
import Combine
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var electricityPrices: [ElectricityPrice] = [] // Lista de precios de electricidad
    @Published var statusMessage: String = "Conectando a la API..." // Mensaje de estado
    @Published var currentDate: String = "" // Fecha actual

    private var cancellables = Set<AnyCancellable>() // Conjunto para almacenar los suscriptores

    // Inicializador para configurar la fecha actual
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        currentDate = dateFormatter.string(from: Date())
    }
    
    // Función para obtener los precios de electricidad para la fecha actual
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
                self?.electricityPrices = prices // Actualiza la lista de precios
                self?.statusMessage = "Datos cargados correctamente."
            case .failure(let error):
                self?.statusMessage = "Error: \(error.localizedDescription)" // Mensaje de error
            }
        }
    }

    // Función para determinar el color basado en el precio
    func colorForPrice(_ price: Double) -> Color {
        switch price {
        case 0..<0.1:
            return .green
        case 0..<0.2:
            return .yellow
        default:
            return .red
        }
    }
}
