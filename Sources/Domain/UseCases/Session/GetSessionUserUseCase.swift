import Foundation

public protocol GetSessionUserUseCase {
    func execute() -> User?
}

public final class GetSessionUserUseCaseImpl: GetSessionUserUseCase {
    private let sessionRepository: SessionRepositoryProtocol

    public init(sessionRepository: SessionRepositoryProtocol) {
        self.sessionRepository = sessionRepository
    }

    public func execute() -> User? {
        self.sessionRepository.getCurrentUser()
    }
}
