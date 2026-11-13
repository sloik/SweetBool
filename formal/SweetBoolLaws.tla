-------------------------- MODULE SweetBoolLaws --------------------------
(* Finite model of Sources/SweetBool (Bool sugar, always) and              *)
(* Sources/SweetPredicate (PredicateType combinators).                     *)
(* A predicate is a function X -> BOOLEAN over a 2-element domain; all 8   *)
(* predicates are enumerated, and cmap functions range over the full       *)
(* function space Y -> X, so each law holds for every predicate/closure.   *)
(* X = Y so cmap composition type-checks. Nil stands for Optional.none. Swift generics are abstracted to X, Y.    *)
EXTENDS Integers

CONSTANTS Mutant   \* "none" for the real semantics, otherwise a seeded bug

X == {0, 1}
Y == {0, 1}
Nil == 9                                \* Optional.none, outside X
Preds   == [X -> BOOLEAN]
PredsY  == [Y -> BOOLEAN]
Contra  == [Y -> X]                     \* the f in cmap(f)
Ints    == -2..2

ConstT == [x \in X |-> TRUE]
ConstF == [x \in X |-> FALSE]

\* ---- PredicateType combinators (PredicateTypeImplementations.swift) ----
Check(p, x) == p[x]
Not(p)    == [x \in X |-> ~p[x]]
And(p, q) == [x \in X |-> IF Mutant = "and_is_or" THEN p[x] \/ q[x] ELSE p[x] /\ q[x]]
Or(p, q)  == [x \in X |-> p[x] \/ q[x]]
Cmap(p, f) ==
  IF Mutant = "cmap_ignores_f"
  THEN [y \in Y |-> p[CHOOSE x \in X : TRUE]]
  ELSE [y \in Y |-> p[f[y]]]
\* optionalOrFalse / optionalOrTrue lift to X \cup {Nil}.
OptOrFalse(p) == [o \in X \cup {Nil} |-> IF o = Nil THEN FALSE ELSE p[o]]
OptOrTrue(p)  == [o \in X \cup {Nil} |-> IF o = Nil THEN TRUE  ELSE p[o]]
\* Internal fast paths (extension with TruePredicate / FalsePredicate args).
AndFalseFast(p) == ConstF
AndTrueFast(p)  == IF Mutant = "and_true_fast_wrong" THEN ConstT ELSE p
OrFalseFast(p)  == p
OrTrueFast(p)   == ConstT

\* ---- Bool sugar (SweetBool.swift) ----
BAnd(a, b) == a /\ b
BOr(a, b)  == a \/ b
ToInt(b)   == IF b THEN 1 ELSE 0
FromInt(n) == IF Mutant = "fromint_positive_only" THEN n > 0 ELSE (IF n < 0 THEN -n ELSE n) > 0
BiTransform(b, yes, no) == IF b THEN yes ELSE no
\* whenTrue / whenFalse: <<returned value, number of closure runs>>
WhenTrue(b)  == <<b, IF b THEN 1 ELSE 0>>
WhenFalse(b) == <<b, IF ~b THEN 1 ELSE 0>>
\* always(b) in its three arities and Bool.always() forward to it.
Always1(b) == [x \in X |-> b]
Always2(b) == [x \in X, y \in Y |-> b]

VARIABLE s
Cfg == [a : BOOLEAN, b : BOOLEAN, n : Ints, p : Preds, q : Preds, r : Preds]
Init == s \in Cfg
Next == UNCHANGED s
Spec == Init /\ [][Next]_s

TypeOK == s \in Cfg

\* ----- Bool sugar -----
BoolSugar ==
  /\ s.a = (s.a = TRUE) /\ ~s.a = (s.a = FALSE)       \* isTrue / isFalse / negated
  /\ BAnd(s.a, s.b) = (s.a /\ s.b) /\ BOr(s.a, s.b) = (s.a \/ s.b)
  /\ BAnd(s.a, s.b) = BAnd(s.b, s.a) /\ BOr(s.a, s.b) = BOr(s.b, s.a)
  /\ ~BAnd(s.a, s.b) = BOr(~s.a, ~s.b)                  \* De Morgan
  /\ ~BOr(s.a, s.b)  = BAnd(~s.a, ~s.b)
  /\ ~(~s.a) = s.a
WhenHooks ==
  /\ WhenTrue(s.a)[1] = s.a /\ WhenFalse(s.a)[1] = s.a
  /\ WhenTrue(s.a)[2] + WhenFalse(s.a)[2] = 1           \* exactly one branch runs
  /\ (WhenTrue(s.a)[2] = 1) <=> s.a
BiTransformIsConditional ==
  \A y, n \in Ints : BiTransform(s.a, y, n) = (IF s.a THEN y ELSE n)
\* toInt: false -> 0, true -> positive; fromInt: 0 -> false, anything else -> true.
ToIntFromIntRoundTrip ==
  /\ FromInt(ToInt(s.a)) = s.a
  /\ ToInt(FALSE) = 0 /\ ToInt(TRUE) > 0
FromIntNonzeroIsTrue == FromInt(s.n) = (s.n # 0)
\* always(b) ignores its arguments and returns b.
AlwaysConstant ==
  /\ \A x \in X : Always1(s.a)[x] = s.a
  /\ \A x \in X, y \in Y : Always2(s.a)[x, y] = s.a

\* ----- Predicate Boolean algebra -----
CheckSemantics ==
  \A x \in X :
    /\ And(s.p, s.q)[x] = (s.p[x] /\ s.q[x])
    /\ Or(s.p, s.q)[x]  = (s.p[x] \/ s.q[x])
    /\ Not(s.p)[x]      = ~s.p[x]
    /\ ConstT[x] /\ ~ConstF[x]
Commutativity == And(s.p, s.q) = And(s.q, s.p) /\ Or(s.p, s.q) = Or(s.q, s.p)
Associativity ==
  /\ And(And(s.p, s.q), s.r) = And(s.p, And(s.q, s.r))
  /\ Or(Or(s.p, s.q), s.r)   = Or(s.p, Or(s.q, s.r))
Idempotence == And(s.p, s.p) = s.p /\ Or(s.p, s.p) = s.p
Absorption  == And(s.p, Or(s.p, s.q)) = s.p /\ Or(s.p, And(s.p, s.q)) = s.p
Distributivity ==
  /\ And(s.p, Or(s.q, s.r)) = Or(And(s.p, s.q), And(s.p, s.r))
  /\ Or(s.p, And(s.q, s.r)) = And(Or(s.p, s.q), Or(s.p, s.r))
DoubleNegation == Not(Not(s.p)) = s.p
DeMorgan ==
  /\ Not(And(s.p, s.q)) = Or(Not(s.p), Not(s.q))
  /\ Not(Or(s.p, s.q))  = And(Not(s.p), Not(s.q))
Complement == And(s.p, Not(s.p)) = ConstF /\ Or(s.p, Not(s.p)) = ConstT
IdentitiesAndAnnihilators ==
  /\ And(s.p, ConstT) = s.p /\ Or(s.p, ConstF) = s.p
  /\ And(s.p, ConstF) = ConstF /\ Or(s.p, ConstT) = ConstT
\* The four internal fast-path overloads must agree with the general combinators.
FastPathsAgree ==
  /\ AndFalseFast(s.p) = And(s.p, ConstF) /\ AndTrueFast(s.p) = And(s.p, ConstT)
  /\ OrFalseFast(s.p)  = Or(s.p, ConstF)  /\ OrTrueFast(s.p)  = Or(s.p, ConstT)

\* ----- cmap (contravariant functor) -----
CmapIdentity == Cmap(s.p, [x \in X |-> x]) = s.p
CmapComposition ==
  \A g \in [X -> X] : \A h \in Contra :
    Cmap(Cmap(s.p, g), h) = Cmap(s.p, [y \in Y |-> g[h[y]]])
CmapDistributes ==
  \A f \in Contra :
    /\ Cmap(Not(s.p), f)      = Not(Cmap(s.p, f))
    /\ Cmap(And(s.p, s.q), f) = And(Cmap(s.p, f), Cmap(s.q, f))
    /\ Cmap(Or(s.p, s.q), f)  = Or(Cmap(s.p, f), Cmap(s.q, f))
    /\ Cmap(ConstT, f) = [y \in Y |-> TRUE] /\ Cmap(ConstF, f) = [y \in Y |-> FALSE]

\* ----- optionalOrFalse / optionalOrTrue -----
OptionalLifting ==
  /\ OptOrFalse(s.p)[Nil] = FALSE /\ OptOrTrue(s.p)[Nil] = TRUE
  /\ \A x \in X : OptOrFalse(s.p)[x] = s.p[x] /\ OptOrTrue(s.p)[x] = s.p[x]
  /\ \A o \in X \cup {Nil} : OptOrTrue(s.p)[o] = ~OptOrFalse(Not(s.p))[o]   \* duality
=============================================================================
