import Foundation

public typealias VoidHandler = () -> Void
public typealias TypeToVoidHandler<T> = (T) -> Void
public typealias ResultHandler<T> = (Result<T, Error>) -> Void
