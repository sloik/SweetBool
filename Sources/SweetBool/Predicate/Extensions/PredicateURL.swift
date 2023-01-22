
import Foundation

extension Predicate {

}

extension String {
    static var isHttp: Predicate<String> {
        .init { str in str.lowercased() == "http" }
    }

    static var isHttps: Predicate<String> {
        .init { str in str.lowercased() == "https" }
    }
}

extension URL {

    static var isHttps: Predicate<URL> {
        String.isHttps.optionalOrFalse.contramap( \URL.scheme )
    }
}
