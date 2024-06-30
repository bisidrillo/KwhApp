import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel // Usar ObservedObject para pasar el ViewModel

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
                                .foregroundColor(viewModel.colorForPrice(price.pricePerKWh)) // Usa la propiedad colorPrecio del modelo
                            VStack(alignment: .leading) {
                                Text("Hora: \(price.hour)")
                                    .font(.headline)
                                Text("Precio: \(price.pricePerKWh, specifier: "%.3f") €/kWh") // Mostrar el precio por kWh
                                    .font(.subheadline)
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle(viewModel.currentDate) // Usar currentDate del viewModel
            .onAppear {
                viewModel.fetchElectricityPrice() // Llamar a fetchElectricityPrice cuando la vista aparezca
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel()) // Pasar el ViewModel como argumento
    }
}
