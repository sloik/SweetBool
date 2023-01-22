
import Foundation

/*:
Q: Why a type that only wraps a function?
A: Because you cna't add extensions to function but you can to types :)
 */

struct Predicate<A> {
    let check: (A) -> Bool
}

// MARK: - Combinators

extension Predicate {


    func or(_ other: Predicate<A>) -> Predicate<A> {
        .init { (a: A) in
            self.check( a ) || other.check( a )
        }
    }

    func and(_ other: Predicate<A>) -> Predicate<A> {
        .init { (a: A) in
            self.check( a ) && other.check( a )
        }
    }

}

// MARK: - Optional

extension Predicate {

    var optionalOrFalse: Predicate<A?> {
        .init { (maybe: A?) in maybe.map( self.check ) ?? false }
    }

    var optionalOrTrue: Predicate<A?> {
        .init { (maybe: A?) in maybe.map( self.check ) ?? true }
    }
}

// MARK: - Contra map

extension Predicate {
    func contramap<FromType>(
        _ f: @escaping (FromType) -> A
    ) -> Predicate<FromType> {

        .init { (new: FromType) in
            let a = f( new )
            return self.check( a )
        }
    }
}
