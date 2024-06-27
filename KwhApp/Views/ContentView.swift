import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.electricityPrices.isEmpty {
                    Text(viewModel.statusMessage)
                        .padding()
                } else {
                    List(viewModel.electricityPrices.sorted(by: { $0.hour < $1.hour }), id: \.id) { price in
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
            .navigationTitle(viewModel.electricityPrices.first.map { "\($0.date)" } ?? "Precios de la Luz")
            .onAppear {
                viewModel.fetchElectricityPrice()
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
