import XCTest
import AliasWonderland

import SweetPredicate

final class PredicateCombinatorPublicAPITests: XCTestCase {


    func test_alwaysTrue_shouldReturnTrue() {
        XCTAssertTrue( PredicateFactory<Any>.alwaysTrue.check{ () } )
    }

    func test_alwaysFalse_shouldReturnTrue() {
        XCTAssertFalse( PredicateFactory<Any>.alwaysFalse.check{ () } )
    }

}
