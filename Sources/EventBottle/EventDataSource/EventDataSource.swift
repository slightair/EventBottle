import Foundation

public struct Event {
    public let date: Date
    public let labels: [String]
    public let body: String

    public init(date: Date, labels: [String], body: String) {
        self.date = date
        self.labels = labels
        self.body = body
    }
}

public protocol EventDataSource: class {
    var events: [Event] { get }

    func load(completion: @escaping (Bool) -> Void)
    func filterdEvents(with searchText: String, completion: @escaping ([Event]) -> Void)
}
