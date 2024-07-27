
import Foundation

/// Type that can represent predicate.
public protocol PredicateType<Element> {
    associatedtype Element

    /// Runs the predicate on input `element`.
    func check(_ element: Element) -> Bool

    /// Contra map for predicate.
    func cmap<FromType>(_ f: @escaping (FromType) -> Element) -> any PredicateType<FromType>
}

// MARK: - Factory

/// Factory type that allows of creating predicates.
public enum PredicateFactory<Of> {

    /// Returns a predicate that ignores input and returns always `true`.
    public static var alwaysTrue: any PredicateType<Of> { TruePredicate() }

    /// Returns a predicate that ignores input and returns always `true`.
    public static var alwaysFalse: any PredicateType<Of> { FalsePredicate() }

    /// Return a predicate that will run given closure later when it's needed.
    public static func create(_ predicateClosure: @escaping (Of) -> Bool) -> any PredicateType<Of> {
        Predicate<Of>(closure: predicateClosure)
    }
}

// MARK: - Combinators Public API

public extension PredicateType {

    /// Returns a new predicate that will have it's logic flipped.
    var not: any PredicateType<Element> {
        NotPredicate(other: self)
    }

    /// Returns a predicate that expects an `Optional`.
    /// Will return `false` when given element is `.none`.
    var optionalOrFalse: any PredicateType<Element?> {
        Predicate { (element: Element?) in
            element.map( self.check(_:) ) ?? false
        }
    }

    /// Returns a predicate that expects an `Optional`.
    /// Will return `true` when given element is `.none`.
    var optionalOrTrue: any PredicateType<Element?> {
        Predicate<Element?> { (element: Element?) in
            element.map( self.check(_:) ) ?? true
        }
    }

    /// Returns a new predicate which is `self && other`.
    func and(_ other: any PredicateType<Element>) -> any PredicateType<Element>  {
        AndPredicate(left: self, right: other)
    }

    /// Returns a new predicate which is `self || other`.
    func or(_ other: any PredicateType<Element>) -> any PredicateType<Element>  {
        OrPredicate(left: self, right: other)
    }
}
