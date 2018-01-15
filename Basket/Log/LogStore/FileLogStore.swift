import Foundation

class FileLogStore: LogStore {
    let fileURL: URL

    init(fileURL: URL) {
        self.fileURL = fileURL
    }

    func putLog(_ log: Any, date: Date, labels: [String]) {
        let line = "date:\(date)\tlabels:\(labels.joined(separator: ","))\tbody:\(String(describing: log))"
        puts(line)
    }
}
