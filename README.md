![Main](https://github.com/sloik/SweetBool/actions/workflows/swift.yml/badge.svg?branch=main)
![Nightly](https://github.com/sloik/SweetBool/actions/workflows/nightly.yml/badge.svg)

# SweetBool

Sugar for working and using Bool type in Swift.

## Why?

To streamline writing and reading code so it will resemble the English language.

# Operators

## `isTrue`

Sugar for checking if `Bool` has value `true`. Streamlines conditionals statements by removing explicit checks with `==`.

```swift
if canDrinkBeer.isTrue {
    ...
```

## `isFalse`

Sugar for checking if `Bool` has value `false`. Streamlines conditionals statements by removing explicit checks with `==`.

```swift
if canDrinkBeer.isFalse {
    ...
```

## `negated`

New instance with negated value.

## `whenTrue`

Operator for running a closure when self is `true`. Use this operator to create pipelines that will trigger actions.

```swift
canDrinkBeer
    .whenTrue { openBeer() }
    .whenFalse { closeBeer() }
```
## `whenFalse` 

Operator for running a closure when self is `false`. Use this operator to create pipelines that will trigger actions.

```swift
canDrinkBeer
    .whenTrue { openBeer() }
    .whenFalse { closeBeer() }
```

## `biTransform(yes:no:)`

Transforms bool to some type of `T`. Use this in longer pipelines where sticking normal operators would break the _flow_:

```swift
manager
    .boolProperty
    .biTransform(yes: "was true", no: "was false")
    .count // working with String now
```

## `and` 

Sugar for `&&`. Writing more complex if statements sometimes is messy. With operators you can write them:

```swift
 if canDrinkBeer
        .and( isHealthy )
        .and( hasMoney )
        .or( isFriend ) {
        ...
```

## `or` 

Sugar for `||`. Writing more complex if statements sometimes is messy. With operators you can write them:

```swift
 if canDrinkBeer
        .and( isHealthy )
        .and( hasMoney )
        .or( isFriend ) {
        ...
```

## `toInt` 

Converts to `Int`. When `true` returns positive value and for `false` returns `0`. Do not assume any particular integer value for `true`.

## `init(fromInt:)`

Creates `Bool` instance from `Int`. When `value` is `0` returns `false` and `true` for all other cases.

# Predicates

## 'always'

When you need a predicate that is always `true` or always `false` you can use a global function like so:

```swift
func takesPredicate<A>(_ p: (A) -> Bool) {... }

// Before

takesPredicate( { _ in true } )

// now

takesPredicate( always(true) )
takesPredicate( true.always )
```

---

# 🐇🕳 Rabbit Hole

This project is part of the [🐇🕳 Rabbit Hole Packages Collection](https://github.com/sloik/RabbitHole)
