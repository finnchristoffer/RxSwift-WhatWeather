//
//  GeoResult.swift
//  WhatWeather
//
//  Created by Finn Christoffer Kurniawan on 11/01/23.
//

import Foundation

extension GeoResult {
    static var empty: GeoResult {
        return GeoResult(lat: nil, lon: nil)
    }
}
struct GeoResult: Decodable {
    let lat: Double?
    let lon: Double?
}
