import Foundation

public class EventBottleFileEventStore: FileEventStore {
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return formatter
    }()

    public static func recordString(from event: Any, date: Date, labels: [String]) -> String {
        let dateString = EventBottleFileEventStore.dateFormatter.string(from: date)
        let labelsString = labels.map { $0.replacingOccurrences(of: "\"", with: "\\\"") }.map { "\"\($0)\"" }.joined(separator: ",")

        return [
            "date:\(dateString)",
            "labels:\(labelsString)",
            "body:\(event)",
        ].joined(separator: "\t")
    }

    override public class func recordData(from event: Any, date: Date, labels: [String]) throws -> Data {
        guard let data = (recordString(from: event, date: date, labels: labels) + "\n").data(using: .utf8) else {
            throw FileEventStoreError.couldNotEncodeEventData
        }
        return data
    }
}
