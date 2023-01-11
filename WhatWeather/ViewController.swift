//
//  ViewController.swift
//  WhatWeather
//
//  Created by Finn Christoffer Kurniawan on 10/01/23.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityNameTextField.rx.value.subscribe(onNext: { city in
            
            if let city = city {
                if city.isEmpty {
                    self.displayWeather(nil)
                } else {
                    self.fetchGeo(by: city)
//                    self.fetchWeather(lat: <#T##Double#>, lon: <#T##Double#>)
                }
            }
        }).disposed(by: disposeBag)
    }

    private func displayWeather(_ weather: Weather?) {
        
        if let weather = weather {
            self.temperatureLabel.text = "\(weather.temp) ℃"
            self.humidityLabel.text = "\(weather.humidity) 🌧️"
        } else {
            self.temperatureLabel.text = "🌡️"
            self.humidityLabel.text = "🌵"
        }
    }
    
    // MARK: - API
    
    private func fetchWeather(lat: Double, lon: Double) {
        guard let url = URL.urlForWeatherAPI(lat: lat, lon: lon) else {
            return
        }

        let resource = Resource<WeatherResult>(url: url)

        URLRequest.load(resource: resource)
            .observe(on: MainScheduler.instance)
            .catchAndReturn(WeatherResult.empty)
            .subscribe(onNext: { result in
                print(result)
                let weather = result.main
                self.displayWeather(weather)
            }).disposed(by: disposeBag)
    }

    
    private func fetchGeo(by city: String) {
            guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
                  let url = URL.urlForGeoAPI(city: cityEncoded) else {
                return
            }
            
            let resource = Resource<[GeoResult]>(url: url)
            
            URLRequest.load(resource: resource)
                        .observe(on: MainScheduler.instance)
                        .catchAndReturn([GeoResult.empty])
                        .subscribe(onNext: { result in
                            print(result.first)
                            guard let geo = result.first else {return}
                            self.fetchWeather(lat: geo.lat, lon: geo.lon)
                        }).disposed(by: disposeBag)

        }

    

}

