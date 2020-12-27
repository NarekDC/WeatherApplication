//
//  FetchedResult.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/26/20.
//


import Foundation
import RealmSwift

public final class Container {
    private let realm: Realm
    
    public convenience init() throws {
        try self.init(realm: Realm())
    }
    
    internal init(realm: Realm) {
        self.realm = realm
        Global.printToConsole(message: Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "can not find the DB path")
    }
    
    public func write(_ block: (WriteTransaction) throws -> Void) throws {
        let transaction = WriteTransaction(realm: realm)
        try realm.write {
            try block(transaction)
            print("save thread: \(Thread.current)")
        }
    }
    
    public func values<T: Persistable> (_ type: T.Type, matching query: T.Query?) -> FetchedResults<T> {
        var results = realm.objects(T.ManagedObject.self)
        if let query = query {
            if let predicate = query.predicate {
                results = results.filter(predicate)
            }
            
            results = results.sorted(by: query.sortDescriptors)
        }
        return FetchedResults(results: results)
    }
}


public final class FetchedResults<T: Persistable> {

    internal let results: Results<T.ManagedObject>

    public var count: Int {
        return results.count
    }

    internal init(results: Results<T.ManagedObject>) {
        self.results = results
    }

    public func value(at index: Int) -> T {
        return T(managedObject: results[index])
    }
}

// MARK: - Collection
extension FetchedResults: Collection {

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return count
    }

    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }

    public subscript(position: Int) -> T {
        return value(at: position)
    }
}

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
