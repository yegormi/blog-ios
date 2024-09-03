import Foundation

public protocol AuthenticateUserUseCase {
    func execute(user: User)
}

public final class AuthenticateUserUseCaseImpl: AuthenticateUserUseCase {
    private let sessionRepository: SessionRepositoryProtocol

    public init(sessionRepository: SessionRepositoryProtocol) {
        self.sessionRepository = sessionRepository
    }

    public func execute(user: User) {
        self.sessionRepository.authenticate(user: user)
    }
}
