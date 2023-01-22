
import Foundation

/*:
Q: Why a type that only wraps a function?
A: Because you cna't add extensions to function but you can to types :)
 */

struct Predicate<A>: PredicateType   {
    private let closure: (A) -> Bool

    init(closure: @escaping (A) -> Bool) {
        self.closure = closure
    }

    public func check(_ element: A) -> Bool {
        closure(element)
    }
}

struct TruePredicate<A>: PredicateType   {
    public func check(_ element: A) -> Bool {
        true
    }
}

struct FalsePredicate<A>: PredicateType   {
    public func check(_ element: A) -> Bool {
        true
    }
}

struct NotPredicate<A>: PredicateType {

    private let other: any PredicateType<A>

    init(other: any PredicateType<A>) {
        self.other = other
    }

    public func check(_ element: A) -> Bool {
        !other.check(element)
    }
}

struct AndPredicate<A>: PredicateType {

    private let left: any PredicateType<A>
    private let right: any PredicateType<A>

    init(left: any PredicateType<A>, right: any PredicateType<A>) {
        self.left = left
        self.right = right
    }

    public func check(_ element: A) -> Bool {
        left.check( element ) && right.check( element )
    }
}

struct OrPredicate<A>: PredicateType {

    private let left: any PredicateType<A>
    private let right: any PredicateType<A>

    init(left: any PredicateType<A>, right: any PredicateType<A>) {
        self.left = left
        self.right = right
    }

    public func check(_ element: A) -> Bool {
        left.check( element ) || right.check( element )
    }
}
