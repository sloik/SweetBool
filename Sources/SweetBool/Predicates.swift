
import Foundation


/// Factory method for creating predicates returning always
/// the given `Bool` value.
///
/// - Parameter b: Instance of `Bool` which will be always return.
/// - Returns: Predicate accepting one argument and returning passed in argument.
public func always<A>(_ b: Bool) -> (A) -> Bool {
    return { _ in
        b
    }
}

/// Factory method for creating predicates returning always
/// the given `Bool` value.
///
/// - Parameter b: Instance of `Bool` which will be always return.
/// - Returns: Predicate accepting two arguments and returning passed in argument.
public func always<A,B>(_ b: Bool) -> (A,B) -> Bool {
    return { _, _ in
        b
    }
}

/// Factory method for creating predicates returning always
/// the given `Bool` value.
///
/// - Parameter b: Instance of `Bool` which will be always return.
/// - Returns: Predicate accepting three arguments and returning passed in argument.
public func always<A,B,C>(_ b: Bool) -> (A,B,C) -> Bool {
    return { _, _, _ in
        b
    }
}

public extension Bool {

    /// Creates a predicate always returning the current bool.
    ///
    /// - Returns: Predicate accepting one argument and returning self as the result.
    func always<A>() -> (A) -> Bool {
        SweetBool.always(self)
    }

    /// Creates a predicate always returning the current bool.
    ///
    /// - Returns: Predicate accepting two arguments and returning self as the result.
    func always<A,B>() -> (A,B) -> Bool {
        SweetBool.always(self)
    }

    /// Creates a predicate always returning the current bool.
    ///
    /// - Returns: Predicate accepting three arguments and returning self as the result.
    func always<A,B,C>() -> (A,B,C) -> Bool {
        SweetBool.always(self)
    }
}
