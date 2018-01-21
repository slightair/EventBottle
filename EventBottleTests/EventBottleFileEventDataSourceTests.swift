import XCTest
import EventBottle

class EventBottleFileEventDataSourceTests: XCTestCase {
    let dummyFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test.events")

    func assertEvent(_ event: Event, date: Date, labels: [String], body: String) {
        XCTAssertEqual(event.date, date)
        XCTAssertEqual(event.labels, labels)
        XCTAssertEqual(event.body, body)
    }

    func testLoadEvents() {
        let subject = EventBottleFileEventDataSource(fileURL: dummyFileURL)

        let testEvents = """
        date:2018-01-01T01:00:00.000Z\tlabels:"test","test\tinclude tab","test\"include, double quote\""\tbody:event1
        date:2018-01-01T02:00:00.000Z\tlabels:"test","dictionary"\tbody:["event": "event2", "count": 1]
        date:2018-01-01T03:00:00.000Z\tlabels:"test","multi line"\tbody:event3
        aaa
        bbb
        ccc
        date:2018-01-01T04:00:00.000Z\tlabels:"test","after multi line"\tbody:event4
        """

        subject.loadTestEvents(testEvents)
        let events = subject.events

        XCTAssertEqual(events.count, 4)

        let date20180101_010000 = Date(timeIntervalSince1970: 1_514_768_400)
        let date20180101_020000 = Date(timeIntervalSince1970: 1_514_772_000)
        let date20180101_030000 = Date(timeIntervalSince1970: 1_514_775_600)
        let date20180101_040000 = Date(timeIntervalSince1970: 1_514_779_200)

        assertEvent(events[0], date: date20180101_010000, labels: ["test", "test\tinclude tab", "test\"include, double quote\""], body: "event1")
        assertEvent(events[1], date: date20180101_020000, labels: ["test", "dictionary"], body: "[\"event\": \"event2\", \"count\": 1]")
        assertEvent(events[2], date: date20180101_030000, labels: ["test", "multi line"], body: "event3\naaa\nbbb\nccc")
        assertEvent(events[3], date: date20180101_040000, labels: ["test", "after multi line"], body: "event4")
    }

    func testParseLabels() {
        XCTAssertEqual(EventBottleFileEventDataSource.parseLabels("\"foo\",\"bar\""), ["foo", "bar"])
        XCTAssertEqual(EventBottleFileEventDataSource.parseLabels("\"test\",\"test\tinclude tab\""), ["test", "test\tinclude tab"])
        XCTAssertEqual(EventBottleFileEventDataSource.parseLabels("\"test\",\"test\\\"include\\\", double quote\""), ["test", "test\"include\", double quote"])
    }
}
