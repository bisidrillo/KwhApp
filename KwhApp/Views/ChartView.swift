//
//  ChartView.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 27/6/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    @StateObject private var viewModel = ChartViewModel()

    var body: some View {
        VStack {
            Text("Precio de la luz por Hora")
                .font(.title)
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
                                y: .value("Precio", data.pricePerKWh)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(Color(hex: data.color))

                            AreaMark(
                                x: .value("Hora", data.hour),
                                y: .value("Precio", data.pricePerKWh)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(Color(hex: data.color).opacity(0.3))

                            PointMark(
                                x: .value("Hora", data.hour),
                                y: .value("Precio", data.pricePerKWh)
                            )
                            .foregroundStyle(Color(hex: data.color))
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
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: .automatic) { _ in
                            AxisGridLine()
                                .foregroundStyle(.blue)
                        }
                    }
                    .frame(height: 250)
                   
                }
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
