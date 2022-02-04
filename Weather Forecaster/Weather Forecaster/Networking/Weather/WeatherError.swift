//
//  WeatherError.swift
//  Weather Forecaster
//
//  Created by Kevin E. Rafferty II on 2/4/22.
//

import Foundation

enum WeatherError: Error {
    case network(description: String)
    case parsing(description: String)
}
