import XCTest
import AliasWonderland

@testable import SweetBool

final class PredicatesTests: XCTestCase {


    func test_truePredicate_shouldReturnTrue() {
        XCTAssertTrue( TruePredicate<Any>().check{ () } )
    }

    func test_falsePredicate_shouldReturnFalse() {
        XCTAssertFalse( FalsePredicate<Any>().check{ () } )
    }

    func test_notPredicate_shouldReturnNegatedValue() {
        XCTAssertTrue(
            NotPredicate<Any>(other: FalsePredicate<Any>() ).check( () )
        )

        XCTAssertFalse(
            NotPredicate<Any>(other: TruePredicate<Any>() ).check( () )
        )
    }

    func test_notOperator_shouldReturnOppositeResultToInputPredicate() {

        XCTAssertFalse(
            TruePredicate<Any>().not.check( () ),
            "Negated true predicate should return false."
        )

        XCTAssertTrue(
            FalsePredicate<Any>().not.check( () ),
            "Negated false predicate should return true."
        )
    }

    func test_andOperator_whenOtherIsFalsePredicate_shouldNotCallInitialPredicateAndUseOtherOne() {
        // Arrange
        let mockedTrue = TruePredicate<Any>()
            .mocked
            .setCheckClosure { _,_ in
                XCTFail( "Predicate and-ed with false will never be true so it should not run!" )
            }

        let sut = mockedTrue.and( FalsePredicate<Any>() )

        // Act
        let result = sut.check( () )

        // Assert
        XCTAssertFalse( result )
    }
}
