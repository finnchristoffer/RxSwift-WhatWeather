//
//  GeoResult.swift
//  WhatWeather
//
//  Created by Finn Christoffer Kurniawan on 11/01/23.
//

import Foundation

extension GeoResult {
    static var empty: GeoResult {
        return GeoResult(lat: 0.0, lon: 0.0)
    }
}
struct GeoResult: Decodable {
    let lat: Double
    let lon: Double
}
