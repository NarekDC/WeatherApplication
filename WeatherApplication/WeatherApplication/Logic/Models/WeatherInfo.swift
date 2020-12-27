//
//  WeatherInfo.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/25/20.
//

import Foundation
import RealmSwift


extension WeatherInfo {
  public enum Query: QueryType {
    case publisherName(String)

    public var predicate: NSPredicate? {
      switch self {
      case .publisherName(let value):
        return NSPredicate(format: "publisher.timezone == %@", value)
      }
    }

    public var sortDescriptors: [SortDescriptor] {
      return [SortDescriptor(keyPath:"timezone")]
    }
  }
}

extension WeatherInfo: Persistable {
        
    public init(managedObject: WeatherInfoObject) {
        timezone = managedObject.timezone
        current = Current(sunrise: 0, sunset: 0, temp: 0, pressure: 0, humidity: 0, clouds: 0, windSpeed: 0)
        current.clouds = managedObject.current!.clouds
        current.windSpeed = Double(managedObject.current!.windSpeed)
        current.humidity = managedObject.current!.humidity
        current.sunset = managedObject.current!.sunset
        current.sunrise = managedObject.current!.sunrise
        current.pressure = managedObject.current!.pressure
        current.temp = Double(managedObject.current!.temp)
        
        var mutatedDaily = [Daily]()
        for element in managedObject.daily {
            let temp = Temp(day: Double(element.temp!.day), night: Double(element.temp!.night))
            let dailyElement = Daily(dt: element.dt, temp: temp)
            mutatedDaily.append(dailyElement)
        }
        
        daily = mutatedDaily
    }
    
    public func managedObject() -> WeatherInfoObject {
        let weatherInfoObject = WeatherInfoObject()
        weatherInfoObject.timezone = timezone
        weatherInfoObject.current?.clouds = current.clouds
        weatherInfoObject.current?.humidity = current.humidity
        weatherInfoObject.current?.pressure = current.pressure
        weatherInfoObject.current?.windSpeed = Int(current.windSpeed)
        weatherInfoObject.current?.sunset = current.sunset
        weatherInfoObject.current?.sunrise = current.sunrise
        weatherInfoObject.current?.temp = Int(current.temp)
                
        for element in daily {
            let dailyObject = DailyObject()
            let temp = TempObject()
            temp.day = Int(element.temp.day)
            temp.night = Int(element.temp.night)
            dailyObject.dt = element.dt
            dailyObject.temp = temp
            weatherInfoObject.daily.append(dailyObject)
        }
        
        return weatherInfoObject
    }
    
}

final class WeatherInfoObject:Object{
    @objc dynamic var timezone = ""
    @objc dynamic var current: CurrentObject? = CurrentObject()
    
    dynamic var daily = List<DailyObject>()

    override static func primaryKey() -> String? {
        return "timezone"
    }
}

final class DailyObject: Object {
    @objc dynamic var dt = 0
    @objc dynamic var temp: TempObject? = TempObject()
    
    override static func primaryKey() -> String? {
        return "dt"
    }
}

final class CurrentObject: Object {
    @objc dynamic var sunrise = 0
    @objc dynamic var sunset = 0
    @objc dynamic var pressure = 0
    @objc dynamic var windSpeed = 0
    @objc dynamic var clouds = 0
    @objc dynamic var humidity = 0
    @objc dynamic var temp = 0

    dynamic var weather = List<WeatherObject>()

    override static func primaryKey() -> String? {
        return "sunrise"
    }
}

final class TempObject: Object {
    @objc dynamic var day = 0
    @objc dynamic var night = 0
    
    override static func primaryKey() -> String? {
        return "day"
    }
}

final class WeatherObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var icon = ""
    

    override static func primaryKey() -> String? {
        return "id"
    }
}
// MARK: - WeatherInfo
struct WeatherInfo: Codable {
    var timezone: String
    var current: Current
    var daily: [Daily]
}

// MARK: - Current
struct Current: Codable {
    var sunrise, sunset: Int
    var temp: Double
    var pressure, humidity: Int
    var clouds: Int
    var windSpeed: Double
    enum CodingKeys: String, CodingKey {
        case sunrise, sunset, pressure, humidity, clouds, temp
        case windSpeed = "wind_speed"
    }

}

// MARK: - Weather
struct Weather: Codable {
    var id: Int
    var icon: String
}

// MARK: - Daily
struct Daily: Codable {
    var dt: Int
    var temp: Temp
}

// MARK: - Temp
struct Temp: Codable {
    var day, night: Double
}
