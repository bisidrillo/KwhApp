import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView(viewModel: ContentViewModel())
                .tabItem {
                    Image(systemName: "bolt.fill")
                    Text("Precios")
                }
            ChartView(viewModel: ChartViewModel())
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Gráfico")
                }
            HoyView(viewModel: HoyViewModel())
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Hoy")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
