// MARK: - 0001-functions

precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

public func |><A, B>(
    x: A,
    f: (A) -> B
) -> B {
    return f(x)
}


precedencegroup ForwardComposition {
    associativity: right
    higherThan: ForwardApplication, EffectfulComposition
}

infix operator >>>: ForwardComposition

public func >>><A, B, C>(
    _ f: @escaping (A) -> B,
    _ g: @escaping (B) -> C
) -> ((A) -> C) {
    return { g(f($0)) }
}

// MARK: - 0002-side-effects

precedencegroup EffectfulComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >=>: EffectfulComposition

public func >=> <A, B, C>(
    _ f: @escaping (A) -> B?,
    _ g: @escaping (B) -> C?
) -> ((A) -> C?) {
    return { a in
        return f(a).flatMap { g($0) }
    }
}

public func >=> <A, B, C>(
    _ f: @escaping (A) -> [B],
    _ g: @escaping (B) -> [C]
) -> ((A) -> [C]) {
    return { a in
        return f(a).flatMap { g($0) }
    }
}

// MARK: - 0003-styling-with-functions

precedencegroup SingleTypeComposition {
    associativity: right
    higherThan: ForwardApplication
}

infix operator <>: SingleTypeComposition

public func <> <A>(
    f: @escaping (A) -> A,
    g: @escaping (A) -> A
) -> (A) -> A {
    return f >>> g
}

public func <> <A>(
    f: @escaping (inout A) -> Void,
    g: @escaping (inout A) -> Void
) -> (inout A) -> Void {
    return { a in
        f(&a)
        g(&a)
    }
}

public func <> <A: AnyObject>(
    f: @escaping (A) -> Void,
    g: @escaping (A) -> Void
) -> (A) -> Void {
    return { a in
        f(a)
        g(a)
    }
}

// MARK: - 0004-algebraic-data-types/

public struct Pair<A, B> {
    let first: A
    let second: B
}

public enum Either<A, B> {
    case left(A)
    case right(B)
}

// MARK: - 0005-higher-order-functions/

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> (C) {
    return { a in { b in f(a, b) } }
}

func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
    return { b in { a in f(a)(b) } }
}

func flip<A, C>(_ f: @escaping (A) -> () -> C) -> () -> (A) -> C {
    return { { a in f(a)() } }
}

func map<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
    return { $0.map(f) }
}

func filter<A>(_ p: @escaping (A) -> Bool) -> ([A]) -> [A] {
    return { $0.filter(p) }
}
