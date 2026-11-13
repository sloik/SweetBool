# Formal model (TLA+)

`SweetBoolLaws.tla` is a finite TLA+ model of the public semantics of `Sources/SweetBool`
(Bool sugar, `always`) and `Sources/SweetPredicate` (`PredicateType` combinators). A predicate
is a function `X -> BOOLEAN` over `X = {0, 1}`; TLC enumerates all 8 predicates (three at a
time) and the full function space for every `cmap` closure, so each law holds for every
predicate and closure, not just examples. Swift generics are abstracted to `X`/`Y`
(`X = Y` so `cmap` composition type-checks); `Optional.none` is the constant `Nil`.

| Invariant | Swift API it abstracts |
|---|---|
| `TypeOK` | state shape |
| `BoolSugar` | `isTrue`, `isFalse`, `negated`, `and`, `or`: equal to `==`/`!`/`&&`/`\|\|`, commutative, De Morgan, double negation |
| `WhenHooks` | `whenTrue` / `whenFalse` return self and exactly one branch closure runs |
| `BiTransformIsConditional` | `biTransform(yes:no:)` |
| `ToIntFromIntRoundTrip`, `FromIntNonzeroIsTrue`, `FromIntTotal` | `toInt`, `init(fromInt:)` (0 -> false, other -> true, never traps; `-2` stands for `Int.min`) |
| `AlwaysConstant` | `always(_:)` free functions and `Bool.always()` (1 and 2 arguments) |
| `CheckSemantics` | `check` of `and` / `or` / `not` / `alwaysTrue` / `alwaysFalse` |
| `Commutativity`, `Associativity`, `Idempotence`, `Absorption`, `Distributivity` | `PredicateType.and` / `or` form a distributive lattice |
| `DoubleNegation`, `DeMorgan`, `Complement` | `not` |
| `IdentitiesAndAnnihilators` | `and(true)`, `or(false)`, `and(false)`, `or(true)` |
| `FastPathsAgree` | internal `and(TruePredicate)` / `and(FalsePredicate)` / `or(...)` overloads agree with the general combinators |
| `CmapIdentity`, `CmapComposition` | `cmap` is a contravariant functor |
| `CmapDistributes` | `cmap` commutes with `not`, `and`, `or`, `alwaysTrue`, `alwaysFalse` |
| `OptionalLifting` | `optionalOrFalse` / `optionalOrTrue` on `.none`, values, and duality |

## Non-vacuity

Each `SweetBoolLaws.<mutant>.cfg` seeds one bug via the `Mutant` constant and names the
invariant that must catch it (`\* EXPECT_VIOLATION: ...`); `run_tlc.sh` fails if a mutant passes.

| Mutant | Seeded bug | Caught by |
|---|---|---|
| `and_is_or` | `and` computed as `\|\|` | `CheckSemantics` |
| `cmap_ignores_f` | `cmap` drops its function | `CmapIdentity` |
| `and_true_fast_wrong` | `and(TruePredicate)` returns always-true | `FastPathsAgree` |
| `fromint_positive_only` | negative ints map to false | `FromIntNonzeroIsTrue` |
| `legacy_abs_trap` | the pre-1.1.4 `abs(Int.min)` trap | `FromIntTotal` |

## Running

```sh
TLA_JAR=/path/to/tla2tools-1.7.4.jar formal/run_tlc.sh   # needs Java 11+
```

The script checks the jar's SHA-256 against the pinned tla2tools 1.7.4. CI runs it on a
self-hosted Oracle ARM64 runner, only on pushes to `main` or by manual dispatch
(`.github/workflows/oracle-tla.yml`). The Swift build and tests stay on hosted macOS.

## Findings

- **Fixed in 1.1.4:** `Bool.init(fromInt:)` was `abs(value) > 0`, and `abs(Int.min)` traps in Swift,
  so `Bool(fromInt: Int.min)` crashed. It is now `value != 0`, and the old bug is the `legacy_abs_trap` mutant.
- `toInt` is specified as "positive for true, do not assume a value"; the model checks only
  `> 0` and `0`.

## Limits

The model describes the *intended* semantics, read by hand from the Swift sources. It does not
prove the Swift code conforms; the XCTest suite covers the code. Existential `any PredicateType`
boxing, closure side effects other than the `whenTrue`/`whenFalse` run count, and laziness
(autoclosure evaluation order) are out of scope. If the Swift behaviour changes, update the
model in the same PR.
