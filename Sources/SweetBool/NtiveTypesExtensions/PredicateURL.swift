
import Foundation


public extension String {

//    static var isHttp: AnyPredicate<String> { String.isCaseInsensitive("http") }
//    var isHttp: Bool { String.isHttp.check( self ) }
//
//    static var isHttps: AnyPredicate<String> { String.isCaseInsensitive("https") }
//    var isHttps: Bool { String.isHttps.check( self ) }
//
//
//    func isExactly(_ str: String) -> AnyPredicate<String> {
//        .init { input in
//            input == str
//        }
//    }
//
//    static func isCaseInsensitive(_ pattern: String) -> AnyPredicate<String> {
//         .init { (checked: String) in
//             pattern.lowercased() == checked.lowercased()
//         }
//    }
}

extension URL {

//    static var isHttps: AnyPredicate<URL> {
//        String.isHttps.optionalOrFalse.contramap( \URL.scheme )
//    }
}
