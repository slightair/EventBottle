import Foundation

struct Log {
    let date: Date
    let labels: [String]
    let body: String
}

protocol LogDataSource: class {
    var logs: [Log] { get }

    func load(completion: @escaping (Bool) -> Void)
}
