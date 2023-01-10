//
//  WeatherResult.swift
//  WhatWeather
//
//  Created by Finn Christoffer Kurniawan on 10/01/23.
//

import Foundation

struct WeatherResult: Decodable {
    let main: Weather
}

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}
