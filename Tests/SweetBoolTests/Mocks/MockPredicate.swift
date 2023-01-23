
import Foundation

import SweetBool
import AliasWonderland

final class MockPredicate<A>: PredicateType {

    let wrapped: any PredicateType<A>

    init(wrapped: any PredicateType<A>) {
        self.wrapped = wrapped
    }

    /// Argument and result of calling wrapped predicate.
    var checkElementClosure: Consumer2I<A,Bool>?

    func check(_ element: A) -> Bool {
        let result = wrapped.check( element )

        checkElementClosure?(element,result)
        return result
    }

    /// Returns a new instance of mocked predicate.
    func setCheckClosure(_ closure: @escaping Consumer2I<A,Bool> ) -> Self {
        self.checkElementClosure = closure
        return self
    }
}

extension PredicateType {
    var mocked: MockPredicate<Element> {
        MockPredicate<Element>(wrapped: self)
    }
}