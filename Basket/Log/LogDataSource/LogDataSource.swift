import Foundation

public struct Log {
    let date: Date
    let labels: [String]
    let body: String
}

public protocol LogDataSource: class {
    var logs: [Log] { get }

    func load(completion: @escaping (Bool) -> Void)
}
