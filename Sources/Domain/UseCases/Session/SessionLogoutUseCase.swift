import Foundation

public protocol SessionLogoutUseCase {
    func execute() throws
}

public final class SessionLogoutUseCaseImpl: SessionLogoutUseCase {
    private let sessionRepository: SessionRepositoryProtocol

    public init(sessionRepository: SessionRepositoryProtocol) {
        self.sessionRepository = sessionRepository
    }

    public func execute() throws {
        try self.sessionRepository.logout()
    }
}
