import Foundation

protocol GetHeroesUseCaseProtocol {
	func execute(offset: Int, limit: Int, completionBlock: @escaping (Result<[CharacterDataModel], Error>) -> Void)
}

struct GetHeroes: GetHeroesUseCaseProtocol {
    private let repository: MarvelRepositoryProtocol

    init(repository: MarvelRepositoryProtocol = MarvelRepository()) {
        self.repository = repository
    }

    func execute(offset: Int, limit: Int, completionBlock: @escaping (Result<[CharacterDataModel], Error>) -> Void) {
		repository.getHeroes(offset: offset, limit: limit, completionBlock: completionBlock)
    }
}
