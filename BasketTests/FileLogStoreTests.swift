import XCTest
import Basket

class FileLogStoreTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testLogString() {
        let date = Date(timeIntervalSince1970: 1514764800) // 2018-01-01 00:00:00 +0000

        let result1 = FileLogStore.logString(log: 123, date: date, labels: ["aaa", "test"])
        let expected1 = "date:2018-01-01T00:00:00.000Z\tlabels:\"aaa\",\"test\"\tbody:123"
        XCTAssertEqual(result1, expected1)

        let result2 = FileLogStore.logString(log: ["hoge": "fuga"], date: date, labels: ["aaa", "test"])
        let expected2 = "date:2018-01-01T00:00:00.000Z\tlabels:\"aaa\",\"test\"\tbody:[\"hoge\": \"fuga\"]"
        XCTAssertEqual(result2, expected2)

        let result3 = FileLogStore.logString(log: "hello\tfuga", date: date, labels: ["\"aaa", "[hoge][fuga],xxx"])
        let expected3 = "date:2018-01-01T00:00:00.000Z\tlabels:\"\\\"aaa\",\"[hoge][fuga],xxx\"\tbody:hello\tfuga"
        XCTAssertEqual(result3, expected3)
    }
}
