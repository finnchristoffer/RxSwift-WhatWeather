//
//  URL+Extentions.swift
//  WhatWeather
//
//  Created by Finn Christoffer Kurniawan on 10/01/23.
//

import Foundation

extension URL {
    
    static func urlForWeatherAPI(lat: Double, lon: Double) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=2df4dea4f9fc62f2ca09f5b8b83b392b&units=metric")
    }
    
    static func urlForGeoAPI(city: String) -> URL? {
        return URL(string: "http://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=1&appid=2df4dea4f9fc62f2ca09f5b8b83b392b")
    }
}
