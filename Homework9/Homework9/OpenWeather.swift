//
//  OpenWeather.swift
//  Homework9
//
//  Created by Jing Yang on 4/24/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import Foundation

struct OpenWeather {
    var coord: Coord;
    var weather: [Weather];
    var base: String;
    var main: Main;
    var visibility: Int;
    var wind: Wind;
    var clouds: Clouds;
    var dt: Int64;
    var sys: Sys;
    var timezone: Int;
    var id: Int;
    var name: String;
    var cod: Int;
}

struct Coord {
    var lon: Float;
    var lat: Float;
}

struct Weather {
    var id: Int;
    var main: String;
    var description: String;
    var icon: String;
}

struct Main {
    var temp: Float;
    var feels_like: Float;
    var temp_min: Float;
    var temp_max: Float;
    var pressure: Int;
    var humidity: Int;
}

struct Wind {
    var speed: Float;
    var deg: Int;
}

struct Clouds {
    var all: Int;
}

struct Sys {
    var type: Int;
    var id: Int;
    var country: String;
    var sunrise: Int32;
    var sunset: Int32;
}
