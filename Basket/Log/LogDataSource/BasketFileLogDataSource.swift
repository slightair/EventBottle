import Foundation

public class BasketFileLogDataSource: FileLogDataSource {
    let dateFormatter = FileLogStore.dateFormatter

    let headerPattern: NSRegularExpression = {
        guard let regexp = try? NSRegularExpression(pattern: "^date:(.+)\tlabels:((?:\".+?\",?)+?)\tbody:(.+)$") else {
            fatalError("Regular expression pattern is invalid")
        }
        return regexp
    }()

    public static func parseLabels(_ labelsString: String) -> [String] {
        return labelsString.split(separator: ",")
            .reduce(Array<String>()) { result, item in
                if item.hasPrefix("\"") {
                    return result + [String(item)]
                } else {
                    if let last = result.last {
                        let label = "\(last),\(item)"
                        return result.dropLast() + [label]
                    }
                    return result
                }
            }
            .map { String($0.dropFirst().dropLast()) }
            .map { $0.replacingOccurrences(of: "\\\"", with: "\"") }
    }

    public override func readLine(_ line: String) {
        if let result = headerPattern.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)) {
            let terms = (1 ..< result.numberOfRanges).map { String(line[Range(result.range(at: $0), in: line)!]) }

            if let currentLogDate = currentLogDate {
                logs.append(Log(date: currentLogDate, labels: currentLogLabels, body: currentLogBody))
            }

            currentLogDate = dateFormatter.date(from: terms[0])
            currentLogLabels = BasketFileLogDataSource.parseLabels(terms[1])
            currentLogBody = terms[2]
        } else {
            currentLogBody += "\n\(line)"
        }
    }

    public override func didLoadLogFile() {
        if let currentLogDate = currentLogDate {
            logs.append(Log(date: currentLogDate, labels: currentLogLabels, body: currentLogBody))
        }
    }
}
