import Foundation

public protocol LogStore {
    func putLog(_ log: Any, date: Date, labels: [String]) throws
}

public extension LogStore {
    public func putLog(_ log: Any, date: Date = Date(), labels: [String] = []) throws {
        try putLog(log, date: date, labels: labels)
    }
}
