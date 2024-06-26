//
//  ChartVista.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 23/6/24.
//

import SwiftUI
import Charts


struct ChartData: Identifiable {
    let id = UUID()
    let hour: String
    let price: Double
}

struct ChartVista: View {
    
    @State private var statusMessage: String = "Conectando a la Api..."
    @State private var electricityPrices: [ChartData] = []
    
    var body: some View {
        VStack {
            Text("Precio de la luz por Hora")
                .font(.title)
                
            
            if electricityPrices.isEmpty {
                if statusMessage == "Conectando a la Api..." {
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
                
                Chart {
                    ForEach(electricityPrices.sorted(by: { $0.hour < $1.hour }))  { data in
                        LineMark(
                            x: .value("Hora", data.hour),
                            y: .value("Precio", data.price)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.orange)
                        .symbol(Circle())
                        
                        // Opcional Añadir area bajo la linea
                        AreaMark(x: .value("hora", data.hour),
                                 y: .value("Precio", data.price)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.orange.opacity(0.3))
                    }
                }
                .chartYScale(domain: 0...0.4) //ajusta el domino de los datos
                .frame(height: 250)
                .padding()
                Spacer()
            }
        }
        .navigationTitle("Grafico")
        .onAppear {
            ApiService.fetchElectricityPrice { result in
                switch result {
                case .success(let prices):
                    electricityPrices = prices.map {
                        ChartData(hour: $0.hour, price: $0.pricePerKWh)
                    }
                    statusMessage = "Datos Cargados correctamente"
                case .failure(let error):
                    statusMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    func fetchElectricityPrice(completion: @escaping (Result<[ElectricityPrice], Error>) -> Void) {
        // Implementacion de la llamada a la api
    }
}
struct ChartVista_PreviewsProvider {
    static var previews: some View {
        ChartVista()
    }
}

#Preview {
    ChartVista()
}
