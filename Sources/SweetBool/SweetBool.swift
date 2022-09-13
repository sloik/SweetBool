
public extension Bool {

    /// Sugar for checking if `Bool` has value `true`.
    ///
    /// Streamlines conditionals statements by removing
    /// explicit checks with `==`.
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
    var negated: Bool {
        !self
    }

    /// Operator for running a closure when self is `true`.
    ///
    /// Use this operator to create pipelines that will trigger actions.
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
    var toInt: Int {
        self ? 1 : 0
    }

    /// Creates `Bool` instance from `Int`.
    /// When `value` is `0` returns `false` and `true` for all other cases.
    init(fromInt value: Int) {
        self = abs(value) > 0
    }
}
