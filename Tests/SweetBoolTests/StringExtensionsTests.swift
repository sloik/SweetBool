import XCTest
import SweetBool

final class StringExtensionsTests: XCTestCase {

    func test_isHttp() {
        XCTAssertTrue("http".isHttp)
        XCTAssertTrue("HTTP".isHttp)
    }

    func test_isHttps() {
        XCTAssertTrue("https".isHttps)
        XCTAssertTrue("HTTPs".isHttps)
    }
}
