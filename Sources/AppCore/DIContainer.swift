import Foundation

public protocol DIContainer {
    func register<T>(_ dependency: T)
    func resolve<T>() -> T
}

public class AppDIContainer: DIContainer {
    private var dependencies: [String: Any] = [:]

    public static var shared: AppDIContainer?

    public static func initialize(_ container: AppDIContainer) {
        self.shared = container
    }

    public init() {}

    public func register<T>(_ dependency: T) {
        let key = String(describing: T.self)
        self.dependencies[key] = dependency
    }

    public func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let dependency = dependencies[key] as? T else {
            fatalError("No dependency found for \(T.self)")
        }
        return dependency
    }
}

@propertyWrapper
public struct Inject<T> {
    public var wrappedValue: T

    public init() {
        guard let container = AppDIContainer.shared else {
            fatalError("AppDIContainer.shared is not set")
        }
        self.wrappedValue = container.resolve()
    }
}
