# Changelog

This project follows [Semantic Versioning 2.0.0](https://semver.org).

## 1.1.4 (2026-11-13): patch

- **Fix:** `Bool(fromInt: Int.min)` crashed. The initializer used `abs(value) > 0`, and
  `abs(Int.min)` overflows. It is now `value != 0`, and `Int.min` returns `true` like every other
  non-zero value. This is a patch release: the documented contract ("`0` is `false`, everything
  else `true`") is unchanged, and the only behaviour that changes is a crash.
- A TLA+ model of the library's laws is checked on CI (`formal/`).
