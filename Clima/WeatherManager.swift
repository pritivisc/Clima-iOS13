//
//  WeatherManager.swift
//  Clima
//
//  Created by Pritivi S Chhabria on 6/30/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=*APPID*"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String) {
        performRequest(with: "\(weatherURL)&q=\(city)")
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        performRequest(with: "\(weatherURL)&lat=\(latitude)&lon=\(longtitude)")
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            return WeatherModel(conditionID: decodedData.weather[0].id,
                                cityName: decodedData.name, temperature: decodedData.main.temp)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
