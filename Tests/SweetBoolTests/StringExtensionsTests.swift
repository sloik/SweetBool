import XCTest
import SweetBool

final class StringExtensionsTests: XCTestCase {

    func test_isHttp() {

        XCTAssertTrue("http".isHttp)
        XCTAssertTrue("HTTP".isHttp)

    }
}
