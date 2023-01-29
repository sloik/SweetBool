
import Foundation

import FuncKeyPath


public extension String {

    static var isHttp: some PredicateType<String> { String.isCaseInsensitive("http") }

    var isHttp: Bool { String.isHttp.check( self ) }

    static var isHttps: some PredicateType<String> { String.isCaseInsensitive("https") }

    var isHttps: Bool { String.isHttps.check( self ) }

    static func isExactly(_ pattern: String) -> some PredicateType<String> {
        Predicate<String> { (checked: String) in
            checked == pattern
        }
    }

    static func isCaseInsensitive(_ pattern: String) -> some PredicateType<String> {
        Predicate<String> { (checked: String) in
             pattern.lowercased() == checked.lowercased()
         }
    }
}

extension URL {

    static var isHttps: any PredicateType<URL> {
        String.isHttps
            .optionalOrFalse
            .cmap( ^\URL.scheme )
    }

    var isHttp: Bool { URL.isHttps.check(self) }
}
