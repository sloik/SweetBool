
import Foundation

public protocol PredicateType<Element> {
    associatedtype Element

    func check(_ element: Element) -> Bool

    /// Contra map for predicate.
    func cmap<FromType>(_ f: @escaping (FromType) -> Element) -> any PredicateType<FromType>
}

// MARK: - Factory

public enum PredicateFactory<Of> {

    /// Returns a predicate that ignores input and returns always `true`.
    public static var alwaysTrue: some PredicateType<Of> { TruePredicate() }

    /// Returns a predicate that ignores input and returns always `true`.
    public static var alwaysFalse: some PredicateType<Of> { FalsePredicate() }

    /// Return a predicate that will run given closure later when it's needed.
    public static func create(_ predicateClosure: @escaping (Of) -> Bool) -> some PredicateType<Of> {
        Predicate<Of>(closure: predicateClosure)
    }
}

// MARK: - Combinators Public API

public extension PredicateType {
    var not: some PredicateType<Element> {
        NotPredicate(other: self)
    }

    var optionalOrFalse: some PredicateType<Element?> {
        Predicate { (element: Element?) in
            element.map( self.check(_:) ) ?? false
        }
    }

    var optionalOrTrue: any PredicateType<Element?> {
        Predicate<Element?> { (element: Element?) in
            element.map( self.check(_:) ) ?? true
        }
    }

    func and(_ other: some PredicateType<Element>) -> some PredicateType<Element>  {
        AndPredicate(left: self, right: other)
    }

    func or(_ other: some PredicateType<Element>) -> some PredicateType<Element>  {
        OrPredicate(left: self, right: other)
    }
}
