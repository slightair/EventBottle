import Foundation

open class FileEventDataStore: EventDataStore {
    public let writeQueue = DispatchQueue.global(qos: .background)

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

    private func openFileIfNeeded() -> FileHandle? {
        if let fileHandle = self.fileHandle {
            return fileHandle
        }

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: fileURL.path) {
            guard fileManager.createFile(atPath: fileURL.path, contents: nil) else {
                assertionFailure("Could not create file")
                return nil
            }
        }

        guard let fileHandle = try? FileHandle(forWritingTo: fileURL) else {
            assertionFailure("Could not open file")
            return nil
        }

        fileHandle.seekToEndOfFile()
        self.fileHandle = fileHandle

        return fileHandle
    }

    public func put(event: Any, date: Date, labels: [String], completion: ((Bool) -> Void)?) {
        writeQueue.async {
            guard let fileHandle = self.openFileIfNeeded() else {
                DispatchQueue.main.async {
                    completion?(false)
                }
                return
            }

            guard let data = type(of: self).recordData(from: event, date: date, labels: labels) else {
                DispatchQueue.main.async {
                    completion?(false)
                }
                return
            }

            fileHandle.write(data)

            DispatchQueue.main.async {
                completion?(true)
            }
        }
    }

    open class func recordData(from _: Any, date _: Date, labels _: [String]) -> Data? {
        assertionFailure("not implemented")

        return nil
    }
}
