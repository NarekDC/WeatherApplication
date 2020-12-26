//
//  WriteTransaction.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/26/20.
//


import Foundation
import RealmSwift

public final class WriteTransaction {
  private let realm: Realm

  internal init(realm: Realm) {
    self.realm = realm
  }

  public func add<T: Persistable>(_ value: T, update: Realm.UpdatePolicy) {
    realm.add(value.managedObject(), update: update)
  }
}

public protocol Persistable {

    associatedtype ManagedObject: Object
    associatedtype Query: QueryType

    init(managedObject: ManagedObject)

    func managedObject() -> ManagedObject
}

public protocol QueryType {
    var predicate: NSPredicate? { get }
    var sortDescriptors: [SortDescriptor] { get }
}

public enum DefaultQuery: QueryType {

    public var predicate: NSPredicate? {
        return nil
    }

    public var sortDescriptors: [SortDescriptor] {
        return []
    }
}
