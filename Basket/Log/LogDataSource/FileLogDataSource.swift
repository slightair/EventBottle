import Foundation

open class FileLogDataSource: LogDataSource {
    public let bufferSize = 4096
    public let loadQueue = DispatchQueue.global(qos: .background)

    public let fileURL: URL

    public var logs: [Log] = []
    public var currentLogDate: Date?
    public var currentLogLabels: [String] = []
    public var currentLogBody: String = ""

    public init(fileURL: URL) {
        self.fileURL = fileURL
    }

    open func reset() {
        logs = []
        currentLogDate = nil
        currentLogLabels = []
        currentLogBody = ""
    }

    open func readLine(_: String) {
    }

    open func didLoadLogFile() {
    }

    public func load(completion: @escaping (Bool) -> Void) {
        reset()

        loadQueue.async {
            guard let handle = try? FileHandle(forReadingFrom: self.fileURL) else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }

            defer {
                handle.closeFile()
            }

            var buffer = Data(capacity: self.bufferSize)
            let delimiter = "\n".data(using: .utf8)!

            var eof = false
            while !eof {
                if let range = buffer.range(of: delimiter) {
                    if let line = String(data: buffer.subdata(in: 0 ..< range.lowerBound), encoding: .utf8) {
                        self.readLine(line)
                    }
                    buffer.removeSubrange(0 ..< range.upperBound)
                    continue
                }

                let data = handle.readData(ofLength: self.bufferSize / 2)
                if data.count > 0 {
                    buffer.append(data)
                } else {
                    eof = true
                    if buffer.count > 0 {
                        if let line = String(data: buffer, encoding: .utf8) {
                            self.readLine(line)
                        }
                        buffer.count = 0
                        continue
                    }
                }
            }

            self.didLoadLogFile()

            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
}
