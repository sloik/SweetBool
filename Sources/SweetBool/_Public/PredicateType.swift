
import Foundation

public protocol PredicateType<Element> {
    associatedtype Element

    func check(_ element: Element) -> Bool
}

public extension PredicateType {

    /// Contra map for predicate.
    func cmap<FromType>(_ f: @escaping (FromType) -> Element) -> any PredicateType<FromType> {
        Predicate { (from: FromType) in
            let element: Element = f( from )
            return self.check( element )
        }
    }
}
