import Foundation

public enum FileEventStoreError: Error {
    case couldNotCreateFile
    case couldNotEncodeEventData
}

public class FileEventStore: EventStore {
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

    public func openFileIfNeeded() throws -> FileHandle {
        if let fileHandle = self.fileHandle {
            return fileHandle
        }

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: fileURL.path) {
            guard fileManager.createFile(atPath: fileURL.path, contents: nil) else {
                throw FileEventStoreError.couldNotCreateFile
            }
        }

        let fileHandle = try FileHandle(forWritingTo: fileURL)
        fileHandle.seekToEndOfFile()
        self.fileHandle = fileHandle

        return fileHandle
    }

    public func put(event _: Any, date _: Date, labels _: [String]) throws {
        assertionFailure("not implemented")
    }
}
