import Foundation
import SwiftUI

struct ElectricityPrice: Identifiable {
    var id: String { date }
    let date: String
    let pricePerKWh: Double
    var timestamp: Date
    let color: String // Se añade la propiedad color
    
    var colorPrecio: Color {
        switch pricePerKWh {
        case 0..<0.1:
            return Color.green // Precio barato
        case 0.1..<0.2:
            return Color.yellow // Precio medio
        default :
            return Color.red // Precio caro
                
        
        }
    }
    
    // Propiedad computada para extraer la hora de la cadena datetime
    var hour: String {
        let dateFormatter = DateFormatter() // Utiliza DateFormatter para convertir la cadena datetime
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" // Configura el formato ISO 8601
        if let date = dateFormatter.date(from: self.date) {
            let calendar = Calendar.current
            let hourComponent = calendar.component(.hour, from: date)
            return String(format: "%02d:00", hourComponent)
        }
        return "N/A" // Devuelve "N/A" si no se puede convertir la fecha
    }
}
