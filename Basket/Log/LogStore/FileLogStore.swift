import Foundation

enum FileLogStoreError: Error {
    case couldNotCreateLogFile
    case couldNotEncodeLogData
}

class FileLogStore: LogStore {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return formatter
    }()

    let fileURL: URL
    var fileHandle: FileHandle?

    init(fileURL: URL) {
        self.fileURL = fileURL
    }

    deinit {
        if let fileHandle = fileHandle {
            fileHandle.closeFile()
        }
    }

    private func openFileIfNeeded() throws -> FileHandle {
        if let fileHandle = self.fileHandle {
            return fileHandle
        }

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: fileURL.path) {
            guard fileManager.createFile(atPath: fileURL.path, contents: nil) else {
                throw FileLogStoreError.couldNotCreateLogFile
            }
        }

        let fileHandle = try FileHandle(forWritingTo: fileURL)
        self.fileHandle = fileHandle

        return fileHandle
    }

    func putLog(_ log: Any, date: Date, labels: [String]) throws {
        let fileHandle = try openFileIfNeeded()
        guard let logData = (FileLogStore.logString(log: log, date: date, labels: labels) + "\n").data(using: .utf8) else {
            throw FileLogStoreError.couldNotEncodeLogData
        }
        fileHandle.write(logData)
    }

    static func logString(log: Any, date: Date, labels: [String]) -> String {
        let dateString = FileLogStore.dateFormatter.string(from: date)
        let labelsString = labels.map{ $0.replacingOccurrences(of: "\"", with: "\\\"") }.map{"\"\($0)\""}.joined(separator: ",")

        return [
            "date:\(dateString)",
            "labels:\(labelsString)",
            "body:\(log)",
        ].joined(separator: "\t")
    }
}
