//
//  WeatherInfoObject.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/26/20.
//

import Foundation
import RealmSwift



extension WeatherInfo: Persistable {
    public init(managedObject: WeatherInfoObject) {
        name = managedObject.name
    }
    
    public func managedObject() -> WeatherInfoObject {
        let weatherInfoObject = WeatherInfoObject()
        weatherInfoObject.name = name
        return weatherInfoObject
    }
    
}

extension WeatherInfo {
  public enum Query: QueryType {
    case publisherName(String)

    public var predicate: NSPredicate? {
      switch self {
      case .publisherName(let value):
        return NSPredicate(format: "publisher.name == %@", value)
      }
    }

    public var sortDescriptors: [SortDescriptor] {
      return [SortDescriptor(keyPath:"name")]
    }
  }
}

final class WeatherInfoObject:Object{
    
    @objc dynamic var name: String = ""
    @objc dynamic var id = 0
    @objc dynamic var dt = 0

    @objc dynamic var sys: WeatherSysObject? = WeatherSysObject()
    @objc dynamic var main: MainObject? = MainObject()
    @objc dynamic var wind: WeatherWindObject? = WeatherWindObject()
    @objc dynamic var clouds: WeatherCloudObject? = WeatherCloudObject()
    
    dynamic var weather = List<WeatherPresentationObject>()

    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class MainObject: Object {
    @objc dynamic var temp = 0
    @objc dynamic var humidity = 0
    @objc dynamic var pressure = 0
    @objc dynamic var tempMin = 0
    @objc dynamic var tempMax = 0

    override static func primaryKey() -> String? {
        return "temp"
    }
}

final class WeatherWindObject: Object {
    @objc dynamic var speed = 0
    @objc dynamic var deg = 0

    
    override static func primaryKey() -> String? {
        return "speed"
    }
}

final class WeatherCloudObject: Object {
    @objc dynamic var all = 0
    
    override static func primaryKey() -> String? {
        return "all"
    }
}

final class WeatherPresentationObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var main = ""
    @objc dynamic var dDescription = ""
    @objc dynamic var icon = ""

    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class WeatherSysObject: Object {
    @objc dynamic var sunrise = 0
    @objc dynamic var sunset = 0
    @objc dynamic var country = ""
    
    override static func primaryKey() -> String? {
        return "country"
    }
}

final class LocationObject: Object {
    @objc dynamic var name = ""
    @objc dynamic var longitude = 0.0
    @objc dynamic var latitude = 0.0
    
    public override static func primaryKey() -> String? {
        return "name"
    }
}

extension APIMeteorite: Persistable {
    
    public init(managedObject: MeteoriteObject) {
        name = managedObject.name
        id = String(managedObject.id)
        recclass = managedObject.recclass
        nametype = managedObject.nametype
        mass = managedObject.mass
        fall = managedObject.fall
        year = managedObject.year
        reclat = managedObject.reclat
        reclong = managedObject.reclong
        geolocation = Geolocation.init(type: "", coordinates: [])
        geolocation?.coordinates = [managedObject.geolocation?.latitude ?? 0.0,managedObject.geolocation?.longitude ?? 0.0]
        geolocation?.type = managedObject.geolocation?.type ?? ""
    }
    
    public func managedObject() -> MeteoriteObject {
        let meteoriteObject = MeteoriteObject()
        meteoriteObject.name = name
        meteoriteObject.id = Int(id) ?? 0
        meteoriteObject.recclass = recclass
        meteoriteObject.nametype = nametype
        meteoriteObject.mass = mass
        meteoriteObject.fall = fall
        meteoriteObject.year = year
        meteoriteObject.reclat = reclat
        meteoriteObject.reclong = reclong
        meteoriteObject.geolocation?.latitude = geolocation?.coordinates[0] ?? 0
        meteoriteObject.geolocation?.longitude = geolocation?.coordinates[1] ?? 0
        meteoriteObject.geolocation?.type = geolocation?.type ?? ""
        meteoriteObject.geolocation?.geoID = Int((geolocation?.coordinates[0] ?? 0)*100000)
        
        return meteoriteObject
    }
    
}

extension APIMeteorite {
  public enum Query: QueryType {
    case publisherName(String)

    public var predicate: NSPredicate? {
      switch self {
      case .publisherName(let value):
        return NSPredicate(format: "publisher.name == %@", value)
      }
    }

    public var sortDescriptors: [SortDescriptor] {
      return [SortDescriptor(keyPath:"name")]
    }
  }
}

final class MeteoriteObject:Object{
    
    @objc dynamic var name: String = ""
    @objc dynamic var id = 0
    @objc dynamic var nametype = ""
    @objc dynamic var recclass = ""
    @objc dynamic var mass: String? = ""
    @objc dynamic var fall: String = ""
    @objc dynamic var year: String? = ""
    @objc dynamic var reclat: String? = ""
    @objc dynamic var reclong: String? = ""
    @objc dynamic var geolocation: GeolocationObject? = GeolocationObject()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class GeolocationObject: Object {
    @objc dynamic var type = ""
    @objc dynamic var longitude = 0.0
    @objc dynamic var geoID = 0
    @objc dynamic var latitude = 0.0
    
    public override static func primaryKey() -> String? {
        return "geoID"
    }

}
