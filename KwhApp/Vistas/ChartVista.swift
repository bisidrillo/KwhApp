//
//  ChartVista.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 23/6/24.
//

import SwiftUI
import Charts

struct ChartVista: View {
    
    @State private var statusMessage: String = "Conectando a la Api..."
    @State private var electricityPrices: [ElectricityPrice] = []
    
    var body: some View {
        VStack {
            Text("Precio de la luz por Hora")
                .font(.title)
                .padding()
            
            if electricityPrices.isEmpty {
                Text(statusMessage)
                    .padding()
            } else {
                Chart {
                    ForEach(electricityPrices.sorted(by: { $0.hour < $1.hour }))  { data in
                        AreaMark(
                            x: .value("hora", data.hour),
                            y: .value("Precio", data.pricePerKWh)
                        )
                        .interpolationMethod(.catmullRom)
                        .symbol(Circle())
                    }
                }
                .chartYScale(domain: 0...1)
                .frame(height: 300)
                .padding()
                .padding()
            }
        }
        .navigationTitle("Grafico")
        .onAppear {
            fetchElectricityPrice { result in
                switch result {
                case .success(let prices):
                    electricityPrices = prices
                    statusMessage = "Datos Cargados correctamente"
                case .failure(let error):
                    statusMessage = "Error: \(error.localizedDescription)"
                }
            
                
            }
        }
    }
}

#Preview {
    ChartVista()
}
