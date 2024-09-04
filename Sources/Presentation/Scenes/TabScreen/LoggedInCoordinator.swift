import DIContainer
import SwiftUI

public enum LoggedInState: Equatable {
    case articles
    case profile
}

public class LoggedInCoordinator: Coordinator {
    @Published public var state: LoggedInState = .articles
    let container: DIContainer

    public init(container: DIContainer) {
        self.container = container
    }

    public func start() async {
        // Additional setup if needed
    }
}
