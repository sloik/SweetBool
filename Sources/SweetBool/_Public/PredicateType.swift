
import Foundation

public protocol PredicateType<Element> {
    associatedtype Element

    func check(_ element: Element) -> Bool

    /// Contra map for predicate.
    func cmap<FromType>(_ f: @escaping (FromType) -> Element) -> any PredicateType<FromType>
}

public extension PredicateType {

}
