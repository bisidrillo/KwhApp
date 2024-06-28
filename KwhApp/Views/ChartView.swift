import SwiftUI
import Charts

struct ChartView: View {
    @StateObject private var viewModel = ChartViewModel()

    var body: some View {
        VStack {
            Text("Precio de la luz por Hora")
                .font(.title3)
                .padding()

            if viewModel.electricityPrices.isEmpty {
                Text(viewModel.statusMessage)
                    .padding()
            } else {
                Chart {
                    ForEach(viewModel.electricityPrices.sorted(by: { $0.hour < $1.hour })) { data in
                        LineMark(
                            x: .value("Hora", data.hour),
                            y: .value("Precio", data.pricePerKWh)
                        )
                        .foregroundStyle(Color(hex: data.color)) // Usa la propiedad color
                    }
                }
                .frame(height: 250)
                .padding()
                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchElectricityPrice()
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
