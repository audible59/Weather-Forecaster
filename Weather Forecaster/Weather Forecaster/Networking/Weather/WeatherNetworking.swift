//
//  WeatherNetworking.swift
//  Weather Forecaster
//
//  Created by Kevin E. Rafferty II on 2/4/22.
//

import Combine
import Foundation

protocol WeatherFetchable {
    
    /// The protocol function will Publish information returned from the OpenWeatherMap API for Hourly Weather
    /// - Returns: The decoded Hourly Weather response along with the WeatherError if an error was encountered.
    func hourlyWeatherForecast(
        forCity city: String
    ) -> AnyPublisher<HourlyWeatherResponse, WeatherError>
    
    /// The protocol function will Publish information returned from the OpenWeatherMap API for Current Weather
    /// - Returns: The decoded Current Weather response along with the WeatherError if an error was encountered.
    func currentWeatherForecast(
        forCity city: String
    ) -> AnyPublisher<CurrentWeatherResponse, WeatherError>
}

class WeatherNetworking {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

// MARK: - Weather Networking

extension WeatherNetworking: WeatherFetchable {
    
    func hourlyWeatherForecast(
        forCity city: String
    ) -> AnyPublisher<HourlyWeatherResponse, WeatherError> {
        
        return forecast(with: hourlyForecastComponents(with: city))
    }
    
    func currentWeatherForecast(
        forCity city: String
    ) -> AnyPublisher<CurrentWeatherResponse, WeatherError> {
        
        return forecast(with: currentDayForecastComponents(with: city))
    }
    
    private func forecast<T>(
        with components: URLComponents
    ) -> AnyPublisher<T, WeatherError> where T: Decodable {
        
        guard let url = components.url else {
            let error = WeatherError.network(description: "Could not create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
            .network(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { pair in
                decode(pair.data)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - OpenWeatherMap API

private extension WeatherNetworking {
    
    struct OpenWeatherAPI {
        static let key = "72c543337934d7aa4934b1bed8e5ca18"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5"
        static let scheme = "https"
    }
    
    func hourlyForecastComponents(
        with city: String
    ) -> URLComponents {
        
        var components = URLComponents()
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.path + "/forecast"
        components.scheme = OpenWeatherAPI.scheme
        
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
        ]
        
        return components
    }
    
    func currentDayForecastComponents(
        with city: String
    ) -> URLComponents {
        
        var components = URLComponents()
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.path + "/weather"
        components.scheme = OpenWeatherAPI.scheme
        
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
        ]
        
        return components
    }
}
