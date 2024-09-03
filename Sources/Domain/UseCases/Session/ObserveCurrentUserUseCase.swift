import Foundation

public protocol ObserveCurrentUserUseCase {
    func execute() -> AsyncStream<User?>
}

public final class ObserveCurrentUserUseCaseImpl: ObserveCurrentUserUseCase {
    private let sessionRepository: SessionRepositoryProtocol

    public init(sessionRepository: SessionRepositoryProtocol) {
        self.sessionRepository = sessionRepository
    }

    public func execute() -> AsyncStream<User?> {
        self.sessionRepository.observeCurrentUser()
    }
}
