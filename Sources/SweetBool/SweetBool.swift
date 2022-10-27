
public extension Bool {

    /// Sugar for checking if `Bool` has value `true`.
    ///
    /// Streamlines conditionals statements by removing
    /// explicit checks with `==`.
    ///
    /// - Returns: Whether the Bool is **true**
    ///
    /// ```swift
    ///
    /// if canDrinkBeer.isTrue {
    ///     ...
    ///
    /// ```
    var isTrue: Bool {
        self
    }

    /// Sugar for checking if `Bool` has value `false`.
    ///
    /// Streamlines conditionals statements by removing
    /// explicit checks with `==`.
    ///
    /// - Returns: Whether the Bool is **false**
    ///
    /// ```swift
    ///
    /// if canDrinkBeer.isFalse {
    ///     ...
    ///
    /// ```
    var isFalse: Bool {
        !self
    }

    /// New instance with negated value.
    ///
    /// - Returns: The logical negation of the current value
    var negated: Bool {
        !self
    }

    /// Operator for running a closure when self is `true`.
    ///
    /// Use this operator to create pipelines that will trigger actions.
    /// - Parameter closure: A closure to execute if the current value is **true**
    /// - Returns: The current value
    ///
    /// ```swift
    ///
    /// canDrinkBeer
    ///     .whenTrue { openBeer() }
    ///     .whenFalse { closeBeer() }
    ///
    /// ```
    @discardableResult
    func whenTrue(_ closure: () -> Void) -> Self {

        if self {
            closure()
        }

        return self
    }

    /// Operator for running a closure when self is `false`.
    ///
    /// Use this operator to create pipelines that will trigger actions.
    ///
    /// - Parameter closure: A closure to execute if the current value is **false**
    /// - Returns: The current value
    ///
    /// ```swift
    ///
    /// canDrinkBeer
    ///     .whenTrue { openBeer() }
    ///     .whenFalse { closeBeer() }
    ///
    /// ```
    @discardableResult
    func whenFalse(_ closure: () -> Void) -> Self {

        if isFalse {
            closure()
        }

        return self
    }

    /// Transforms bool to some type of `T`.
    ///
    /// Use this in longer pipelines where sticking normal operators
    /// would break the _flow_:
    ///
    /// - Parameter yes: A transform returning type T if the current value is **true**
    /// - Parameter no: A transform returning type T if the current value is **false**
    /// - Returns: A type T that is the result of the matching transform
    ///
    /// ```swift
    ///
    /// manager
    ///     .boolProperty
    ///     .biTransform(yes: "was true", no: "was false")
    ///     .count // working with String now
    ///
    /// ```
    @discardableResult
    func biTransform<T>(
        yes: @autoclosure () -> T,
        no: @autoclosure () -> T
    ) -> T {
        self ? yes() : no()
    }
}

// MARK: - Logic Operators

public extension Bool {

    /// Sugar for `&&`.
    ///
    /// Writing more complex if statements sometimes is messy.
    /// With operators you can write them:
    ///
    /// - Parameter other: A Bool value
    /// - Returns: The result of the logical **AND** between the current value and **other**
    ///
    /// ```swift
    ///
    ///  if canDrinkBeer
    ///         .and( isHealthy )
    ///         .and( hasMoney )
    ///         .or( isFriend ) {
    ///         ...
    /// ```
    @discardableResult
    func and(_ other: Bool) -> Bool {
        self && other
    }

    /// Sugar for `||`.
    ///
    /// Writing more complex if statements sometimes is messy.
    /// With operators you can write them:
    ///
    /// - Parameter other: A Bool value
    /// - Returns: The result of the logical **OR** between the current value and **other**
    ///
    /// ```swift
    ///
    ///  if canDrinkBeer
    ///         .and( isHealthy )
    ///         .and( hasMoney )
    ///         .or( isFriend ) {
    ///         ...
    /// ```
    @discardableResult
    func or(_ other: Bool) -> Bool {
        self || other
    }
}

// MARK: - Numeric

public extension Bool {

    /// Converts to `Int`. When `true` returns positive value
    /// and for `false` returns `0`. Do not assume any particular
    /// integer value for `true`.
    ///
    /// - Returns: The Int representation of the current value
    ///
    var toInt: Int {
        self ? 1 : 0
    }

    /// Creates `Bool` instance from `Int`.
    /// When `value` is `0` returns `false` and `true` for all other cases.
    ///
    /// - Parameter value: An Int value
    /// - Returns: The Bool representation of **value**
    ///
    init(fromInt value: Int) {
        self = abs(value) > 0
    }
}
