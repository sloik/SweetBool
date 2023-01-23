
import Foundation

/*:
 Q: Why a type that only wraps a function?
 A: Because you cna't add extensions to function but you can to types :)
 */

struct Predicate<A>: PredicateType {
    private let closure: (A) -> Bool

    init(closure: @escaping (A) -> Bool) {
        self.closure = closure
    }

    public func check(_ element: A) -> Bool {
        closure(element)
    }
}

struct TruePredicate<A>: PredicateType {
    public func check(_ element: A) -> Bool {
        true
    }
}

struct FalsePredicate<A>: PredicateType {
    public func check(_ element: A) -> Bool {
        false
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

extension PredicateType {

    var not: any PredicateType<Element> {
        NotPredicate(other: self)
    }

    func cmap<FromType>(_ f: @escaping (FromType) -> Element) -> any PredicateType<FromType> {
        Predicate { (from: FromType) in
            let element: Element = f( from )
            return self.check( element )
        }
    }

    func and(_ other: any PredicateType<Element>) -> any PredicateType<Element>  {
        AndPredicate(left: self, right: other)
    }

    // and with `false` always returns `false`
    func and(_ other: FalsePredicate<Element>) -> any PredicateType<Element> { other }

    // and with `true` will always be the value of self
    func and(_ other: TruePredicate<Element>) -> any PredicateType<Element> { self }

    func or(_ other: any PredicateType<Element>) -> any PredicateType<Element>  {
        OrPredicate(left: self, right: other)
    }

    func or(_ other: FalsePredicate<Element>) -> any PredicateType<Element>  {
        self
    }

    func or(_ other: TruePredicate<Element>) -> any PredicateType<Element> {
        other
    }
}
