
import Foundation

extension Predicate {

}

public extension String {

    static var isHttp: Predicate<String> { String.isCaseInsensitive("http") }
    var isHttp: Bool { String.isHttp.check( self ) }

    static var isHttps: Predicate<String> { String.isCaseInsensitive("https") }
    var isHttps: Bool { String.isHttps.check( self ) }


    func isExactly(_ str: String) -> Predicate<String> {
        .init { input in
            input == str
        }
    }

    static func isCaseInsensitive(_ pattern: String) -> Predicate<String> {
         .init { (checked: String) in
             pattern.lowercased() == checked.lowercased()
         }
    }
}

//extension URL {
//
//    static var isHttps: Predicate<URL> {
//
//        "".isHttp.check
//        String.isHttps.optionalOrFalse.contramap( \URL.scheme )
//    }
//}
