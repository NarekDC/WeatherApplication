//
//  WeatherInfo.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/25/20.
//

import Foundation

struct WeatherInfo: Codable {
//    let sys: WeatherSys
//    let weather: [WeatherPresentation]
//    let main: Main
//    let wind: WeatherWind
//    let clouds: WeatherClouds
//    let dt, id: Int
    let name: String
}

struct WeatherClouds: Codable {
    let all: Int
}

struct Main: Codable {
    let temp: Double
    let humidity, pressure: Int
    let tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, humidity, pressure
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct WeatherSys: Codable {
    let country: String
    let sunrise, sunset: Int
}

struct WeatherPresentation: Codable {
    let id: Int
    let main, description, icon: String
}

struct WeatherWind: Codable {
    let speed, deg: Double
}

struct APIMeteorite:Decodable {
      let name, id, nametype, recclass: String
      let mass: String?
      let fall: String
      let year: String?
      let reclat, reclong: String?
      var geolocation: Geolocation?
    
    init(name:String,
         id:String,
         nametype:String,
         recclass:String,
         mass:String?,
         fall:String,
         year:String?,
         reclat:String?,
         reclong:String?,
         geolocation:Geolocation) {
        self.name = name
        self.id = id
        self.geolocation = geolocation
        self.mass = mass
        self.nametype = nametype
        self.recclass = recclass
        self.reclat = reclat
        self.reclong = reclong
        self.fall = fall
        self.year = year
    }
}

enum APINULL:String, Error {
    case noSize = "-1"
    case noYear = "NoYear"
}

extension APIMeteorite: Meteorite {
    var mName: String { name }
    var mFall:String { fall }
    var mSize: Double {
        if let nMass = Double(mass ?? APINULL.noSize.rawValue) {
            return nMass
        }else {
            return Double(APINULL.noSize.rawValue)!
        }
    }
    var mDate: String { year?.components(separatedBy: "T")[0] ?? APINULL.noYear.rawValue }
    var mLocation: Geolocation { geolocation ?? Geolocation(type: "Point", coordinates: [360,360]) }
}

struct Geolocation: Codable {
    var type: String
    var coordinates: [Double]
    var location: Coordinates{ Coordinates(latitude: coordinates[1],
                                           longitude: coordinates[0])
                              }
    init(type:String,coordinates:[Double]) {
        self.type = type
        self.coordinates = coordinates
    }
}

struct Coordinates {
    var latitude:Double
    var longitude:Double
    var isEmpty:Bool{
        return latitude == 360 && longitude == 360
    }
}

protocol Meteorite {
    var mName: String{ get }
}
