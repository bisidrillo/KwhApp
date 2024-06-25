import SwiftUI

struct ContentView: View {
    @State private var statusMessage: String = "Conectando a la API..."
    @State private var electricityPrices: [ElectricityPrice] = []

    var body: some View {
        NavigationView {
            VStack {
                if electricityPrices.isEmpty {
                    Text(statusMessage)
                        .padding()
                } else {
                    List(electricityPrices.sorted(by: { $0.hour < $1.hour }), id:  \.id ) { price in
                        HStack {
                            Image(systemName: "eurosign.arrow.trianglehead.counterclockwise.rotate.90")
                                .resizable()
                                .frame(width: 20, height: 18)
                                .foregroundColor(iconColor(for: price.priceLevel))
                            VStack(alignment: .leading) {
                                Text("Hora: \(price.hour)")
                                    .font(.headline)
                                Text("Precio: \(price.pricePerKWh, specifier: "%.3f") €/kWh")
                                    .font(.subheadline)
                                Text("Es barato: \(price.isCheap ? "Sí" : "No")")
                                    .font(.subheadline)
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle(electricityPrices.first.map { "\($0.date)" } ?? "Precios de la Luz")
            .onAppear {
                ApiService.fetchElectricityPrice { result in
                    switch result {
                    case .success(let prices):
                        electricityPrices = prices
                        statusMessage = "Datos cargados correctamente."
                    case .failure(let error):
                        statusMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }
        }
    }

    func iconColor(for priceLevel: String) -> Color {
        switch priceLevel {
        case "cheap":
            return .green
        case "medium":
            return .yellow
        case "expensive":
            return .red
        default:
            return .gray
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
