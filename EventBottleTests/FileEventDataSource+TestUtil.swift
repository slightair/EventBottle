import Foundation
import EventBottle

extension FileEventDataSource {
    func loadTestEvents(_ events: String) {
        reset()

        var buffer = events.data(using: .utf8)!
        let delimiter = "\n".data(using: .utf8)!

        var eof = false
        while !eof {
            if let range = buffer.range(of: delimiter) {
                if let line = String(data: buffer.subdata(in: 0 ..< range.lowerBound), encoding: .utf8) {
                    readLine(line)
                }
                buffer.removeSubrange(0 ..< range.upperBound)
                continue
            }

            eof = true
            if buffer.count > 0 {
                if let line = String(data: buffer, encoding: .utf8) {
                    readLine(line)
                }
                buffer.count = 0
                continue
            }
        }

        didLoadEvents()
    }
}
