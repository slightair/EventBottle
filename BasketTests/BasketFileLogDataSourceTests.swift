import XCTest
import Basket

class BasketFileLogDataSourceTests: XCTestCase {
    let dummyFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test.log")

    func assertLog(_ log: Log, date: Date, labels: [String], body: String) {
        XCTAssertEqual(log.date, date)
        XCTAssertEqual(log.labels, labels)
        XCTAssertEqual(log.body, body)
    }

    func testLoadLogs() {
        let subject = BasketFileLogDataSource(fileURL: dummyFileURL)

        let testLog = """
date:2018-01-01T01:00:00.000Z\tlabels:"test","test\tinclude tab","test\"include, double quote\""\tbody:event1
date:2018-01-01T02:00:00.000Z\tlabels:"test","dictionary"\tbody:["event": "event2", "count": 1]
date:2018-01-01T03:00:00.000Z\tlabels:"test","multi line"\tbody:event3
aaa
bbb
ccc
date:2018-01-01T04:00:00.000Z\tlabels:"test","after multi line"\tbody:event4
"""

        subject.loadTestLog(testLog)
        let logs = subject.logs

        XCTAssertEqual(logs.count, 4)

        let date20180101_010000 = Date(timeIntervalSince1970: 1514768400)
        let date20180101_020000 = Date(timeIntervalSince1970: 1514772000)
        let date20180101_030000 = Date(timeIntervalSince1970: 1514775600)
        let date20180101_040000 = Date(timeIntervalSince1970: 1514779200)

        assertLog(logs[0], date: date20180101_010000, labels: ["test", "test\tinclude tab", "test\"include, double quote\""], body: "event1")
        assertLog(logs[1], date: date20180101_020000, labels: ["test", "dictionary"], body: "[\"event\": \"event2\", \"count\": 1]")
        assertLog(logs[2], date: date20180101_030000, labels: ["test","multi line"], body: "event3\naaa\nbbb\nccc")
        assertLog(logs[3], date: date20180101_040000, labels: ["test","after multi line"], body: "event4")
    }

    func testParseLabels() {
        XCTAssertEqual(BasketFileLogDataSource.parseLabels("\"foo\",\"bar\""), ["foo", "bar"])
        XCTAssertEqual(BasketFileLogDataSource.parseLabels("\"test\",\"test\tinclude tab\""), ["test", "test\tinclude tab"])
        XCTAssertEqual(BasketFileLogDataSource.parseLabels("\"test\",\"test\\\"include\\\", double quote\""), ["test", "test\"include\", double quote"])
    }
}
