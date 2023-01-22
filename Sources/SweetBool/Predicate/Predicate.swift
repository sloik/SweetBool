
import Foundation

/*:
Q: Why a type that only wraps a function?
A: Because you cna't add extensions to function but you can to types :)
 */

public struct Predicate<A> {
    let check: (A) -> Bool
}

// MARK: - Combinators

public extension Predicate {

    var not: Predicate<A> {
        .init { (a: A) in
            !check(a)
        }
    }

    // self [1,2,3], other [3,4,5], result: [1,2,3,4,5]
    func or(_ other: Predicate<A>) -> Predicate<A> {
        .init { (a: A) in
            self.check( a ) || other.check( a )
        }
    }

    // self [1,2,3], other [3,4,5], result: [3]
    func and(_ other: Predicate<A>) -> Predicate<A> {
        .init { (a: A) in
            self.check( a ) && other.check( a )
        }
    }

    // self [1,2,3], other [3,4,5], result: [1,2]
    func complement(_ other: Predicate<A>) -> Predicate<A> {
        self.and( other.not )
    }

    // self [1,2,3], other [3,4,5], result: [4,5]
    func difference(_ other: Predicate<A>) -> Predicate<A> {
        self.not.and( other )
    }
}

// MARK: - Optional

public extension Predicate {

    var optionalOrFalse: Predicate<A?> {
        .init { (maybe: A?) in maybe.map( self.check ) ?? false }
    }

    var optionalOrTrue: Predicate<A?> {
        .init { (maybe: A?) in maybe.map( self.check ) ?? true }
    }
}

// MARK: - Contra map

public extension Predicate {
    func contramap<FromType>(
        _ f: @escaping (FromType) -> A
    ) -> Predicate<FromType> {

        .init { (new: FromType) in
            let a = f( new )
            return self.check( a )
        }
    }
}
