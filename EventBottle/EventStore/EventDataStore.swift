import Foundation

public protocol EventDataStore {
    func put(event: Any, date: Date, labels: [String]) throws
}

public extension EventDataStore {
    public func putEvent(_ event: Any, date: Date = Date(), labels: [String] = []) throws {
        try put(event: event, date: date, labels: labels)
    }
}
