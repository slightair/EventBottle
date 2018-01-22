import Foundation

public protocol EventDataStore {
    func put(event: Any, date: Date, labels: [String], completion: ((Bool) -> Void)?)
}

public extension EventDataStore {
    public func putEvent(_ event: Any, date: Date = Date(), labels: [String] = [], completion: ((Bool) -> Void)? = nil) {
        put(event: event, date: date, labels: labels, completion: completion)
    }
}
