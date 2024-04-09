//
//  Service.swift
//  WeatherApp
//
//  Created by Kadish Bernardo Ribeiro da Silva on 21/03/24.
//

import Foundation

struct City {
    let lat: String
    let lon: String
    let name: String
}

class Service {
    private let baseURL: String = "https://api.openweathermap.org/data/3.0/onecall"
    private let apiKey: String = "7e5024aef01547fe31b7cacd96c0be27"
    private let session = URLSession.shared
    
    func fecthData(city: City,_ completion: @escaping (ForecastResponse?) -> Void) {
        let urlString = "\(baseURL)?lat=\(city.lat)&lon=\(city.lon)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { return }
        
        let task = session.dataTask(with: url) {data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let forecatsResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(forecatsResponse)
            } catch {
                //print(error)
                print(String(data: data, encoding: .utf8) ?? "")
                completion(nil)
                
            }
        }
        task.resume()
    }
}

// MARK: - ForecastResponse
struct ForecastResponse: Codable {
    let current: Forecast
    let hourly: [Forecast]
    let daily: [DailyForecast]
}

// MARK: - Forecast
struct Forecast: Codable {
    let dt: Int
    let temp: Double
    let humidity: Int
    let windSpeed: Double
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt, temp, humidity
        case windSpeed = "wind_speed"
        case weather
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Daily
struct DailyForecast: Codable {
    let dt: Int
    let temp: Temp
    let weather: [Weather]
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

