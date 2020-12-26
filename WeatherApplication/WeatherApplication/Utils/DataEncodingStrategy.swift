//
//  DataEncodingStrategy.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/25/20.
//

import Foundation

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    static let iso8601noFS: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let customISO8601 = custom { decoder throws -> Date in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = Formatter.iso8601.date(from: string) ?? Formatter.iso8601noFS.date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}

extension JSONEncoder.DateEncodingStrategy {
    static let customISO8601 = custom { date, encoder throws in
        var container = encoder.singleValueContainer()
        try container.encode(Formatter.iso8601.string(from: date))
    }
}
