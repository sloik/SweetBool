
import Foundation


// TODO: move this operator to other framework... single one?
prefix operator ^

prefix func ^ <Root, Value>(keyPath: KeyPath<Root, Value>) -> (Root) -> Value {
  return { root in root[keyPath: keyPath] }
}
