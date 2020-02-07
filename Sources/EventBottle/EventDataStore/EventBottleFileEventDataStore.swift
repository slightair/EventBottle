import Foundation

public class EventBottleFileEventDataStore: FileEventDataStore {
    public static let shared = EventBottleFileEventDataStore()!

    public convenience init?() {
        self.init(for: "default")
    }

    public convenience init?(for name: String) {
        guard let fileURL = EventBottleFileEventDataStore.fileURL(for: name) else {
            assertionFailure("Could not locate event file")
            return nil
        }
        self.init(fileURL: fileURL)
    }

    static func fileURL(for name: String) -> URL? {
        guard let libraryCacheURL = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            return nil
        }

        let eventsDirectory = "cc.clv.EventBottle"
        let fileName = "\(name)_\(Int(Date().timeIntervalSince1970)).events"

        return libraryCacheURL.appendingPathComponent(eventsDirectory).appendingPathComponent(fileName)
    }

    public var dataSource: EventBottleFileEventDataSource {
        return EventBottleFileEventDataSource(fileURL: fileURL)
    }

    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return formatter
    }()

    public static func recordString(from event: Any, date: Date, labels: [String]) -> String {
        let dateString = dateFormatter.string(from: date)
        let labelsString = labels.map { $0.replacingOccurrences(of: "\"", with: "\\\"") }.map { "\"\($0)\"" }.joined(separator: ",")

        return [
            "date:\(dateString)",
            "labels:\(labelsString)",
            "body:\(event)",
        ].joined(separator: "\t")
    }

    public override class func recordData(from event: Any, date: Date, labels: [String]) -> Data? {
        return (recordString(from: event, date: date, labels: labels) + "\n").data(using: .utf8)
    }
}
