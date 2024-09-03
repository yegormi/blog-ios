import Foundation

public protocol Coordinator: ObservableObject {
    associatedtype State
    var state: State { get set }
    func start()
}
