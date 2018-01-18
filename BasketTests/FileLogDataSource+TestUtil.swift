import Foundation
import Basket

extension FileLogDataSource {
    func loadTestLog(_ log: String) {
        reset()

        var buffer = log.data(using: .utf8)!
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

            eof = true
            if buffer.count > 0 {
                if let line = String(data: buffer, encoding: .utf8) {
                    self.readLine(line)
                }
                buffer.count = 0
                continue
            }
        }

        self.didLoadLogFile()
    }
}
