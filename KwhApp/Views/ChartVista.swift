import SwiftUI
import Charts

struct ChartData: Identifiable {
    let id = UUID()
    let hour: String
    let price: Double
}
enum TimeRange: String, CaseIterable, Identifiable {
    case day = "Dia"
    case week = "Semana"
    case sixMounts = "6 Meses"
    case yeat = "Año"
    
    
    var id: String { self.rawValue }
}

struct ChartView {
    <#fields#>
}

    var body: some View {
        VStack {
            Text("Precio de la luz por Hora")
                .font(.title3)
                .padding()
            Picker("Rango de tiempo", selection: $selectedTimeRange) {
                ForEach(TimeRange.allCases) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if electricityPrices.isEmpty {
                if statusMessage == "Conectando a la API..." {
                    TimelineView(.animation) { context in
                        let currentTime = context.date.timeIntervalSinceReferenceDate
                        let progress = currentTime.truncatingRemainder(dividingBy: 1)
                        VStack {
                            Text(statusMessage)
                            ProgressView(value: progress)
                                .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                                .scaleEffect(1.5)
                                .padding()
                        }
                    }
                } else {
                    Text(statusMessage)
                        .padding()
                }
            } else {
                GroupBox{
                    Chart {
                        ForEach(electricityPrices.sorted(by: { $0.hour < $1.hour })) { data in
                            LineMark(
                                x: .value("Hora", data.hour),
                                y: .value("Precio", data.price)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(.orange)
                            .symbol(Circle())
                            
                            AreaMark(
                                x: .value("Hora", data.hour),
                                y: .value("Precio", data.price)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(.orange.opacity(0.3))
                        }
                    }
                }
                .chartYScale(domain: 0...0.4) // Ajusta el dominio de los datos
                .chartYAxis {
                    AxisMarks(values: .stride(by: 0.1)) { value in
                        AxisGridLine()
                            .foregroundStyle(.blue) // Cambia el color de las líneas de la cuadrícula a azul
                        AxisTick()
                            .foregroundStyle(.blue) // Cambia el color de las marcas de tic a azul
                        AxisValueLabel() {
                            if let price = value.as(Double.self) {
                                Text("\(price, specifier: "%.1f")")
                                    .foregroundColor(.blue) // Cambia el color de las etiquetas a azul
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisGridLine()
                            .foregroundStyle(.blue) // Cambia el color de las líneas de la cuadrícula a azul
                        AxisTick()
                            .foregroundStyle(.blue) // Cambia el color de las marcas de tic a azul
                        
                    }
                }
                .frame(height: 250)
                .padding()
                Spacer()
            }
        }
        .navigationTitle("Gráfico")
        .onAppear {
            ApiService.fetchElectricityPrice { result in
                switch result {
                case .success(let prices):
                    electricityPrices = prices.map {
                        ChartData(hour: $0.hour, price: $0.pricePerKWh)
                    }
                    statusMessage = "Datos cargados correctamente"
                case .failure(let error):
                    statusMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct ChartVista_Previews: PreviewProvider {
    static var previews: some View {
        ChartVista()
    }
}
