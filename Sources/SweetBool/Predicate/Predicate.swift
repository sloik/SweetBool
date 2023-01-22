
import Foundation

/*:
Q: Why a type that only wraps a function?
A: Because you cna't add extensions to function but you can to types :)
 */

struct Predicate<A> {
    let check: (A) -> Bool
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
