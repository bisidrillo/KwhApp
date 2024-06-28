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
                    Image(systemName: "chart.bar.xaxis")
                    Text("Gráfico")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
