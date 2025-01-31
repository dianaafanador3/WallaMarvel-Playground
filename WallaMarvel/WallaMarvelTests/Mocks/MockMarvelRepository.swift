//
//  MockMarvelRepository.swift
//  WallaMarvel
//
//  Created by Diana Perez Afanador on 31/1/25.
//

@testable import WallaMarvel

class MockMarvelRepository: MarvelRepositoryProtocol {
	var shouldReturnError = false
	var mockHeroDetail: DetailCharacterDataModel?
	var mockHeros: [CharacterDataModel] = []

	func getHeroDetail(by id: Int, completionBlock: @escaping (Result<DetailCharacterDataModel, Error>) -> Void) {
		if shouldReturnError {
			completionBlock(.failure(APIClientError.dataCorrupted))
		} else if let mockHeroDetail = mockHeroDetail {
			completionBlock(.success(mockHeroDetail))
		}
	}

	func getHeroes(offset: Int, limit: Int, completionBlock: @escaping (Result<[CharacterDataModel], any Error>) -> Void) {
		if shouldReturnError {
			completionBlock(.failure(APIClientError.dataCorrupted))
		} else {
			completionBlock(.success(mockHeros))
		}
	}
}
