import Foundation

public protocol GetTokenUseCase {
    func execute() throws -> String?
}

public final class GetTokenUseCaseImpl: GetTokenUseCase {
    private let sessionRepository: SessionRepositoryProtocol

    public init(sessionRepository: SessionRepositoryProtocol) {
        self.sessionRepository = sessionRepository
    }

    public func execute() throws -> String? {
        try self.sessionRepository.getToken()
    }
}
