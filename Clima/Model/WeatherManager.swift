//
//  WeatherManager.swift
//  Clima
//
//  Created by Gaurav Bhambhani on 6/25/23.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    // adding one more func for catching and passing errors out of the weather manager
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let APIKEY = "35d59e912f8b9ebfc3d34bd7bf162bd4"
    let urlString = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    
    var delegate: WeatherManagerDelegate?

    func fetchWeather(cityName: String) {
        let weatherString = "\(urlString)&q=\(cityName)&appid=\(APIKEY)"
        performRequest(with: weatherString)
    }
    
    func fetchWeather(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        let weatherString = "\(urlString)&lat=\(lat)&lon=\(lon)&appid=\(APIKEY)"
        performRequest(with: weatherString)
    }
    
    func performRequest(with weatherString: String) {
        if let url = URL(string: weatherString) {
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
//                    print(error!)
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedWeatherJSON = try decoder.decode(WeatherData.self, from: weatherData)
     
            let weatherId = decodedWeatherJSON.weather[0].id
            let temp = decodedWeatherJSON.main.temp
            let name = decodedWeatherJSON.name

            let weatherModel = WeatherModel(conditionId: weatherId, temperature: temp, cityName: name)
            
            return weatherModel
            
        } catch {
//            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    // this handle function can be made into an anonymous function using closures.
    
//    func handle(data: Data?, urlResponse: URLResponse?, error: Error?) {
//        if error != nil {
//            print(error!)
//            return
//        }
//
//        if let safeData = data {
//            let receivedDataString = String(data: safeData, encoding: .utf8)
//            print(receivedDataString!)
//        }
//    }
}
