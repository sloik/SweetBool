import XCTest
import SweetBool

final class PredicateTests: XCTestCase {

    func test_always() {

        XCTAssertTrue(
            true.always()(42)
        )

        XCTAssertTrue(
            true.always()(42, "42")
        )

        XCTAssertTrue(
            true.always()(42, "42", Date())
        )

        XCTAssertFalse(
            false.always()(42)
        )

        XCTAssertFalse(
            false.always()(42, "42")
        )

        XCTAssertFalse(
            false.always()(42, "42", Date())
        )
    }
}
