# Electricity Price Viewer

Electricity Price Viewer es una aplicación de iOS desarrollada con SwiftUI que permite a los usuarios ver los precios de la electricidad por hora en tiempo real utilizando la API pública de [preciodelaluz.org](https://api.preciodelaluz.org/). La aplicación presenta los precios en una lista y en un gráfico para facilitar su visualización.

## Estado del Proyecto

⚠️ **Este proyecto está en construcción y está siendo utilizado como una herramienta de aprendizaje.** ⚠️

## Características

- Muestra una lista de precios de electricidad por hora con detalles como fecha, hora, precio en €/kWh y si es barato o no.
- Visualiza los precios de la electricidad en un gráfico interactivo.
- Datos obtenidos en tiempo real desde la API pública de [preciodelaluz.org](https://api.preciodelaluz.org/).

## Requisitos

- iOS 14.0 o superior
- Xcode 12.0 o superior
- Conexión a Internet para obtener los datos de la API

## Instalación

1. Clona este repositorio en tu máquina local:
    ```sh
    git clone https://github.com/tu-usuario/electricity-price-viewer.git
    ```

2. Abre el proyecto en Xcode:
    ```sh
    cd electricity-price-viewer
    open ElectricityPriceViewer.xcodeproj
    ```

3. Selecciona el simulador o dispositivo deseado y ejecuta la aplicación.

## Uso

1. Al abrir la aplicación, la pantalla principal mostrará una lista de precios de electricidad por hora.
2. La segunda pestaña muestra un gráfico interactivo con los precios de la electricidad por hora.
3. El título de navegación muestra la fecha de los datos obtenidos de la API.

## Estructura del Proyecto

```plaintext
ElectricityPriceViewer
│
├── ElectricityPriceViewerApp.swift  // Punto de entrada de la aplicación
├── MainView.swift                   // Contiene el TabView para la navegación
├── ContentView.swift                // Muestra la lista de precios de la electricidad
├── SecondView.swift                 // Muestra el gráfico de precios de la electricidad
└── ApiService.swift                 // Maneja la obtención de datos de la API
