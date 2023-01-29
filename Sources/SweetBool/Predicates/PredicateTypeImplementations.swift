
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

    func cmap<FromType>(_ f: @escaping (FromType) -> A) -> any PredicateType<FromType> {
        Predicate<FromType> { (from: FromType) in
            let a = f( from )

            return closure(a)
        }
    }
}

struct TruePredicate<A>: PredicateType {
    public func check(_ element: A) -> Bool {
        true
    }

    func cmap<FromType>(_ f: @escaping (FromType) -> Element) -> any PredicateType<FromType> {
         TruePredicate<FromType>()
    }
}

struct FalsePredicate<A>: PredicateType {
    public func check(_ element: A) -> Bool {
        false
    }

    func cmap<FromType>(_ f: @escaping (FromType) -> Element) -> any PredicateType<FromType> {
         FalsePredicate<FromType>()
    }
}

struct NotPredicate<A>: PredicateType {

    private let other: any PredicateType<A>

    init(other: some PredicateType<A>) {
        self.other = other
    }

    public func check(_ element: A) -> Bool {
        !other.check(element)
    }

    func cmap<FromType>(_ f: @escaping (FromType) -> A) -> any PredicateType<FromType> {
        NotPredicate<FromType>(other: other.cmap( f ))
    }
}

struct AndPredicate<A>: PredicateType {

    private let left: any PredicateType<A>
    private let right: any PredicateType<A>

    init(left: some PredicateType<A>, right: some PredicateType<A>) {
        self.left = left
        self.right = right
    }

    public func check(_ element: A) -> Bool {
        left.check( element ) && right.check( element )
    }

    func cmap<FromType>(_ f: @escaping (FromType) -> A) -> any PredicateType<FromType> {
        AndPredicate<FromType>(
            left: self.left.cmap( f ),
            right: self.right.cmap( f )
        )
    }
}

struct OrPredicate<A>: PredicateType {

    private let left: any PredicateType<A>
    private let right: any PredicateType<A>

    init(left: some PredicateType<A>, right: some PredicateType<A>) {
        self.left = left
        self.right = right
    }

    public func check(_ element: A) -> Bool {
        left.check( element ) || right.check( element )
    }

    func cmap<FromType>(_ f: @escaping (FromType) -> A) -> any PredicateType<FromType> {
        OrPredicate<FromType>(
            left: self.left.cmap( f ),
            right: self.right.cmap( f )
        )
    }
}

extension Predicate {
    var optionalOrFalse: Predicate<A?> {
        .init { (a: A?) in
            a.map(check) ?? false
        }
    }
}

// MARK: - Combinators Internal API

extension PredicateType {

    /// Anything AND `false` always returns `false` so we can just return other.
    func and(_ other: FalsePredicate<Element>) -> some PredicateType<Element> {
        other
    }

    // AND with `true` will always be the value of self.
    func and(_ other: TruePredicate<Element>) -> some PredicateType<Element> {
        self
    }

    /// OR with `false` will always have the value of `self`.
    func or(_ other: FalsePredicate<Element>) -> some PredicateType<Element>  {
        self
    }

    /// OR with `true` will always have the value of `true`.
    func or(_ other: TruePredicate<Element>) -> some PredicateType<Element> {
        other
    }
}

