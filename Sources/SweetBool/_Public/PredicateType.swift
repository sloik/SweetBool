
import Foundation

public protocol PredicateType<Element> {
    associatedtype Element

    func check(_ element: Element) -> Bool
}
