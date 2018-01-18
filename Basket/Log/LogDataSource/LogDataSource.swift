import Foundation

public struct Log {
    public let date: Date
    public let labels: [String]
    public let body: String
}

public protocol LogDataSource: class {
    var dateFormatter: DateFormatter { get }

    var logs: [Log] { get }

    func load(completion: @escaping (Bool) -> Void)
}

extension LogDataSource {
    public var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }
}
