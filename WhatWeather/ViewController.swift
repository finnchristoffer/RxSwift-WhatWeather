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
        
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.cityNameTextField.text}
            .subscribe(onNext: {city in
                
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchGeo(by: city)
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

//        let search = URLRequest.load(resource: resource)
//            .observe(on: MainScheduler.instance)
//            .asDriver(onErrorJustReturn: WeatherResult.empty)
//
        
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .catchError { error in
                print(error.localizedDescription)
                return Observable.just(WeatherResult.empty)
            }.asDriver(onErrorJustReturn: WeatherResult.empty)
        
        search.map { "\($0.main.temp) ℃" }
            .drive(self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map { "\($0.main.humidity) 💦"}
            .drive(self.humidityLabel.rx.text)
            .disposed(by: disposeBag)
    }

    
    private func fetchGeo(by city: String) {
            guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
                  let url = URL.urlForGeoAPI(city: cityEncoded) else {
                return
            }
            
            let resource = Resource<[GeoResult]>(url: url)
            
            URLRequest.load(resource: resource)
                        .observe(on: MainScheduler.instance)
                        .retry(3)
                        .catchAndReturn([GeoResult.empty])
                        .subscribe(onNext: { result in
                            guard let geo = result.first, let lat = geo.lat, let lon = geo.lon else {return}
                            self.fetchWeather(lat: lat, lon: lon)
                        }).disposed(by: disposeBag)

        }
}

