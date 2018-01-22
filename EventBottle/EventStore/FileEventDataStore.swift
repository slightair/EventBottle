import Foundation

public enum FileEventDataStoreError: Error {
    case couldNotCreateFile
    case couldNotEncodeEventData
}

open class FileEventDataStore: EventDataStore {
    public let fileURL: URL
    private var fileHandle: FileHandle?

    public init(fileURL: URL) {
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
                throw FileEventDataStoreError.couldNotCreateFile
            }
        }

        let fileHandle = try FileHandle(forWritingTo: fileURL)
        fileHandle.seekToEndOfFile()
        self.fileHandle = fileHandle

        return fileHandle
    }

    public func put(event: Any, date: Date, labels: [String]) throws {
        let fileHandle = try openFileIfNeeded()
        let data = try type(of: self).recordData(from: event, date: date, labels: labels)

        fileHandle.write(data)
    }

    open class func recordData(from _: Any, date _: Date, labels _: [String]) throws -> Data {
        assertionFailure("not implemented")

        throw FileEventDataStoreError.couldNotEncodeEventData
    }
}
