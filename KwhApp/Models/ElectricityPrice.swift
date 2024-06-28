//
//  ElectricityPrice.swift
//  KwhApp
//
//  Created by Isidro Jose Suarez Rodriguez on 27/6/24.
//

import Foundation

struct ElectricityPrice: Identifiable {
    var id: String { date }
    let date: String
    let pricePerKWh: Double
    let color: String // Se añade la propiedad color
    
    // Propiedad computada para determinar si el precio es barato
    var isCheap: Bool {
        return pricePerKWh < 0.1
    }
    
    // Propiedad computada para extraer la hora de la cadena datetime
    var hour: String {
        let dateFormatter = DateFormatter() // Utiliza DateFormatter para convertir la cadena datetime
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" // Configura el formato ISO 860
        if let date = dateFormatter.date(from: self.date) {
            let calendar = Calendar.current
            let hourComponent = calendar.component(.hour, from: date)
            return String(format: "%02d:00", hourComponent)
        }
        return "N/A" // Devuelve "N/A" si no se puede convertir la fecha
    }
    
    // Método para formatear la cadena datetime a un formato deseado
    func formattedDate(format: String) -> String {
        let dateFormatter = DateFormatter() // Utiliza DateFormatter para convertir la cadena datetime
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" // Configura el formato ISO 8601
        if let date = dateFormatter.date(from: self.date) {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
        return "N/A" // Devuelve "N/A" si no se puede convertir la fecha
    }
    
    // Propiedad computada para determinar el nivel de precio
    var priceLevel: String {
        if pricePerKWh < 0.1 {
            return "cheap"
        } else if pricePerKWh < 0.2 {
            return "medium"
        } else {
            return "expensive"
        }
    }
}
