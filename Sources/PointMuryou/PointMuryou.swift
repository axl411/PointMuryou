precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication
public func |><A, B>(x: A, f: (A) -> B) -> B {
    return f(x)
}


precedencegroup ForwardComposition {
    higherThan: ForwardApplication
    associativity: right
}

infix operator >>>: ForwardComposition
public func >>><A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> ((A) -> C) {
    return { a in g(f(a)) }
}
