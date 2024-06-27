//
//  MainView.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 23/6/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "bolt.fill")
                    Text("Precios")
                }
            ChartView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis.ascending.badge.clock.rtl")
                    Text("Grafico")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
        
        
    }
}
