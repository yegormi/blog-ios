import Combine
import DIContainer
import Foundation
import OSLog
import Presentation
import SwiftUI

private let logger = Logger(subsystem: "AppCore", category: "AppCore")

@MainActor
public struct AppCore {
    private let coordinator: AppCoordinator

    public init() {
        let container = AppDIContainer()
        AppDIContainer.initialize(container)

        let registrar = DependencyRegistrar(container: container)
        registrar.registerDependencies()

        self.coordinator = AppCoordinator(container: container)
    }

    public func makeRootView() -> some View {
        AppCoordinatorView(coordinator: self.coordinator)
            .task {
                await self.coordinator.start()
            }
    }
}
