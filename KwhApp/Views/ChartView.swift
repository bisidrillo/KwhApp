import SwiftUI
import Charts

struct ChartData: Identifiable {
    let id = UUID()
    let hour: String
    let price: Double
}

enum TimeRange: String, CaseIterable, Identifiable {
    case day = "Día"
    case week = "Semana"
    case sixMonths = "6 Meses"
    case year = "Año"
    
    var id: String { self.rawValue }
}

struct ChartView: View {
    @StateObject private var viewModel = ChartViewModel()

    var body: some View {
        VStack {
            Text("Precio de la luz por Hora")
                .font(.title3)
                .padding()
            Picker("Rango de tiempo", selection: $viewModel.selectedTimeRange) {
                ForEach(TimeRange.allCases) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if viewModel.electricityPrices.isEmpty {
                if viewModel.statusMessage == "Conectando a la API..." {
                    TimelineView(.animation) { context in
                        let currentTime = context.date.timeIntervalSinceReferenceDate
                        let progress = currentTime.truncatingRemainder(dividingBy: 1)
                        VStack {
                            Text(viewModel.statusMessage)
                            ProgressView(value: progress)
                                .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                                .scaleEffect(1.5)
                                .padding()
                        }
                    }
                } else {
                    Text(viewModel.statusMessage)
                        .padding()
                }
            } else {
                GroupBox {
                    Chart {
                        ForEach(viewModel.electricityPrices.sorted(by: { $0.hour < $1.hour })) { data in
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
                .chartYScale(domain: 0...0.4)
                .chartYAxis {
                    AxisMarks(values: .stride(by: 0.1)) { value in
                        AxisGridLine()
                            .foregroundStyle(.blue)
                        AxisTick()
                            .foregroundStyle(.blue)
                        AxisValueLabel() {
                            if let price = value.as(Double.self) {
                                Text("\(price, specifier: "%.1f")")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisGridLine()
                            .foregroundStyle(.blue)
                        AxisTick()
                            .foregroundStyle(.blue)
                    }
                }
                .frame(height: 250)
                .padding()
                Spacer()
            }
        }
        .navigationTitle("Gráfico")
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
