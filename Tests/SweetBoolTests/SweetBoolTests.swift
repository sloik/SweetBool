import XCTest
import SweetBool

final class SweetBoolTests: XCTestCase {
    
    func test_isTrue() throws {

        XCTAssertTrue(
            true.isTrue
        )

        XCTAssertFalse(
            false.isTrue
        )
    }

    func test_isFalse() throws {

        XCTAssertFalse(
            true.isFalse
        )

        XCTAssertTrue(
            false.isFalse
        )
    }

    func test_negated() {
        XCTAssertTrue( false.negated )
        XCTAssertFalse( true.negated )
    }

    func test_whenTrue_whenIsTrue_shouldExecuteClosure() {

        // Arrange
        let didCall = expectation(description: "Did not call!")

        // Act
        true
            .whenTrue {
                didCall.fulfill()
            }
            .whenFalse {
                XCTFail("Should not execute false branch closure.")
            }

        // Assert
        waitForExpectations(timeout: 0.01)
    }

    func test_whenFalse_whenIsTrue_shouldExecuteClosure() {

        // Arrange
        let didCall = expectation(description: "Did not call!")


        // Act
        false
            .whenFalse {
                didCall.fulfill()
            }
            .whenTrue {
                XCTFail("Should not execute true branch closure.")
            }

        // Assert
        waitForExpectations(timeout: 0.01)
    }

    func test_toInt() {
        XCTAssertEqual(false.toInt, 0)

        XCTAssertGreaterThan(
            true.toInt,
            0,
            "Should convert to value greater than zero!"
        )
    }

    func test_initFromValue() {

        // Arrange
        let randomPositiveInt: Int = Int.random(in: 1...Int.max)

        let randomNegativeInt = Int.random(in: Int.min..<0)

        // Act & assert
        XCTAssertTrue(
            Bool(fromInt: randomPositiveInt),
            "Non zero should be treated as true"
        )

        XCTAssertTrue(
            Bool(fromInt: randomNegativeInt),
            "Zero should be treated as false"
        )

        XCTAssertFalse(
            Bool(fromInt: 0),
            "Zero should be treated as false"
        )

        XCTAssertTrue( Bool(fromInt: true.toInt) )
        XCTAssertFalse( Bool(fromInt: false.toInt) )
    }

    func test_biTransform() {

        XCTAssertEqual(
            true.biTransform(yes: "yes", no: "no"),
            "yes"
        )

        XCTAssertEqual(
            false.biTransform(yes: "yes", no: "no"),
            "no"
        )
    }

    func test_and() {

        XCTAssertEqual(
            true.and( true ),
            true && true
        )

        XCTAssertEqual(
            true.and( false ),
            true && false
        )

        XCTAssertEqual(
            false.and( true ),
            false && true
        )

        XCTAssertEqual(
            false.and( false ),
            false && false
        )
    }

    func test_or() {

        XCTAssertEqual(
            true.or( true ),
            true || true
        )

        XCTAssertEqual(
            true.or( false ),
            true || false
        )

        XCTAssertEqual(
            false.or( true ),
            false || true
        )

        XCTAssertEqual(
            false.or( false ),
            false || false
        )
    }
}
