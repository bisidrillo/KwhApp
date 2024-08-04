import SwiftUI

struct HoyView: View {
    @ObservedObject var viewModel: HoyViewModel
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            DatePicker("Fecha", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(DefaultDatePickerStyle())
                .onChange(of: selectedDate) { newDate in
                    viewModel.fetchElectricityPrice(for: newDate)
                }
                .padding()

            if viewModel.statusMessage.isEmpty {
                if let currentPrice = viewModel.currentPrice {
                    Text("Precio actual: \(currentPrice.pricePerKWh, specifier: "%.3f") €/kWh")
                        .font(.title)
                        .padding(.top, 10)
                        .foregroundColor(currentPrice.colorPrecio)
                }

                if let averagePrice = viewModel.averagePrice {
                    Text("Precio medio: \(averagePrice, specifier: "%.3f") €/kWh")
                        .font(.title2)
                        .padding(.top, 5)
                        .foregroundColor(.indigo)
                }

                if let minPrice = viewModel.minPrice {
                    Text("Precio mínimo: \(minPrice.pricePerKWh, specifier: "%.3f") €/kWh a las \(minPrice.timestamp, formatter: DateFormatter.hourFormatter)")
                        .font(.subheadline)
                        .foregroundStyle(.green)
                        .padding(.top, 5)
                }

                if let maxPrice = viewModel.maxPrice {
                    Text("Precio máximo: \(maxPrice.pricePerKWh, specifier: "%.3f") €/kWh a las \(maxPrice.timestamp, formatter: DateFormatter.hourFormatter)")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .padding(.top, 5)
                }
            } else {
                Text(viewModel.statusMessage)
                    .padding()
            }

            Spacer()
        }
        .navigationTitle("Hoy")
        .onAppear {
            viewModel.fetchElectricityPrice(for: selectedDate)
        }
        .padding(.top, 0)
    }
}

struct HoyView_Previews: PreviewProvider {
    static var previews: some View {
        HoyView(viewModel: HoyViewModel())
    }
}

extension DateFormatter {
    static let hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
