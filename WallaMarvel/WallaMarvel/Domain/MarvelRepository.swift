import Foundation

protocol MarvelRepositoryProtocol {
	func getHeroes(offset: Int, limit: Int, completionBlock: @escaping (Result<[CharacterDataModel], Error>) -> Void)
	func getHeroDetail(by id: Int, completionBlock: @escaping (Result<DetailCharacterDataModel, Error>) -> Void)
}

final class MarvelRepository: MarvelRepositoryProtocol {
	private let dataSource: MarvelDataSourceProtocol

	init(dataSource: MarvelDataSourceProtocol = MarvelDataSource()) {
		self.dataSource = dataSource
	}

	func getHeroes(offset: Int, limit: Int, completionBlock: @escaping (Result<[CharacterDataModel], Error>) -> Void) {
		dataSource.getHeroes(offset: offset, limit: limit, completionBlock: completionBlock)
	}

	func getHeroDetail(by id: Int, completionBlock: @escaping (Result<DetailCharacterDataModel, Error>) -> Void) {
		dataSource.getHeroDetail(by: id, completionBlock: completionBlock)
	}
}
