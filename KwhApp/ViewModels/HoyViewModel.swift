import Foundation
import Combine
import SwiftUI

class HoyViewModel: ObservableObject {
    @Published var electricityPrices: [ElectricityPrice] = []
    @Published var statusMessage: String = "Conectando a la API..."
    @Published var averagePrice: Double?
    @Published var minPrice: ElectricityPrice?
    @Published var maxPrice: ElectricityPrice?
    @Published var currentPrice: ElectricityPrice?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchElectricityPrice(for date: Date) {
        ApiService.fetchElectricityPrice(for: date) { [weak self] (result: Result<[ElectricityPrice], Error>) in
            switch result {
            case .success(let prices):
                self?.electricityPrices = prices
                self?.averagePrice = prices.map { $0.pricePerKWh }.reduce(0, +) / Double(prices.count)
                self?.minPrice = prices.min(by: { $0.pricePerKWh < $1.pricePerKWh })
                self?.maxPrice = prices.max(by: { $0.pricePerKWh < $1.pricePerKWh })
                self?.statusMessage = ""
                self?.setCurrentPrice()
            case .failure(let error):
                self?.statusMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
    
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
    
    private func setCurrentPrice() {
        let currentHour = Calendar.current.component(.hour, from: Date())
        if let currentPrice = electricityPrices.first(where: { Calendar.current.component(.hour, from: $0.timestamp) == currentHour }) {
            self.currentPrice = currentPrice
        } else {
            self.currentPrice = nil
        }
    }
}
