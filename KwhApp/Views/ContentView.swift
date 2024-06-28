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
                            Image(systemName: "eurosign.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color(hex: price.color)) // Usa la propiedad color
                            VStack(alignment: .leading) {
                                Text("Hora: \(price.hour)")
                                    .font(.headline)
                                Text("Precio: \(price.pricePerKWh, specifier: "%.3f") €/kWh")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
