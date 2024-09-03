import Combine
import DIContainer
import Foundation
import OSLog
import Presentation
import SwiftUI

private let logger = Logger(subsystem: "AppCore", category: "AppCore")

@MainActor
public struct AppCore {
    private let container: DIContainer
    private let coordinator: AppCoordinator

    public init() {
        let container = AppDIContainer()
        let registrar = DependencyRegistrar(container: container)
        registrar.registerDependencies()
        self.container = container
        AppDIContainer.initialize(container)

        self.coordinator = AppCoordinator(container: container)
    }

    public func makeRootView() -> some View {
        AppCoordinatorView(coordinator: self.coordinator)
            .onAppear {
                self.coordinator.start()
            }
    }
}
