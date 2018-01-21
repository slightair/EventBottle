import Foundation

public struct Event {
    public let date: Date
    public let labels: [String]
    public let body: String
}

public protocol EventDataSource: class {
    var dateFormatter: DateFormatter { get }

    var events: [Event] { get }

    func load(completion: @escaping (Bool) -> Void)
}

extension EventDataSource {
    public var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }
}
