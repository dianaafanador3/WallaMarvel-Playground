import Foundation

protocol MarvelDataSourceProtocol {
    func getHeroes(offset: Int, limit: Int, completionBlock: @escaping (Result<[CharacterDataModel], Error>) -> Void)
	func getHeroDetail(by id: Int, completionBlock: @escaping (Result<DetailCharacterDataModel, Error>) -> Void)
}

final class MarvelDataSource: MarvelDataSourceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

	func getHeroes(offset: Int, limit: Int, completionBlock: @escaping (Result<[CharacterDataModel], Error>) -> Void) {
		return apiClient.getHeroes(offset: offset, limit: limit, completionBlock: completionBlock)
    }

	func getHeroDetail(by id: Int, completionBlock: @escaping (Result<DetailCharacterDataModel, Error>) -> Void) {
		return apiClient.getHeroDetail(by: id, completionBlock: completionBlock)
	}
}
