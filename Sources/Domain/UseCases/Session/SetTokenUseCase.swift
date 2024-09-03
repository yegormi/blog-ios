import Foundation

public protocol SetTokenUseCase {
    func execute(token: String) throws
}

public final class SetTokenUseCaseImpl: SetTokenUseCase {
    private let sessionRepository: SessionRepositoryProtocol

    public init(sessionRepository: SessionRepositoryProtocol) {
        self.sessionRepository = sessionRepository
    }

    public func execute(token: String) throws {
        try self.sessionRepository.setToken(token)
    }
}
