//
//  CurrentWeatherResponse.swift
//  Weather Forecaster
//
//  Created by Kevin E. Rafferty II on 2/4/22.
//

import Foundation

struct CurrentWeatherResponse: Decodable {
    let main: Main
    let coord: Coord
    
    struct Main: Codable {
        let temperature: Double
        let humidity: Int
        let maxTemperature: Double
        let minTemperature: Double
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case humidity
            case maxTemperature = "temp_max"
            case minTemperature = "temp_min"
        }
    }
    
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }
}
