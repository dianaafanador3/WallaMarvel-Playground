//
//  GetHeroDetail.swift
//  WallaMarvel
//
//  Created by Diana Perez Afanador on 30/1/25.
//

protocol GetHeroDetailUseCaseProtocol {
	func execute(id: Int, completionBlock: @escaping (Result<DetailCharacterDataModel, Error>) -> Void)
}

struct GetHeroDetail: GetHeroDetailUseCaseProtocol {
	private let repository: MarvelRepositoryProtocol

	init(repository: MarvelRepositoryProtocol = MarvelRepository()) {
		self.repository = repository
	}

	func execute(id: Int, completionBlock: @escaping (Result<DetailCharacterDataModel, Error>) -> Void) {
		repository.getHeroDetail(by: id, completionBlock: completionBlock)
	}
}
