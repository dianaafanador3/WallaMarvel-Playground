//
//  MockGetHeroUseCase.swift
//  WallaMarvel
//
//  Created by Diana Perez Afanador on 31/1/25.
//

@testable import WallaMarvel

class MockGetHeroesUseCase: GetHeroesUseCaseProtocol {
	var shouldReturnError = false
	var mockHeroes: [CharacterDataModel] = []

	func execute(offset: Int, limit: Int, completionBlock: @escaping (Result<[CharacterDataModel], Error>) -> Void) {
		if shouldReturnError {
			completionBlock(.failure(MockGetHeroUseCaseError.generic))
		} else {
			completionBlock(.success(mockHeroes))
		}
	}
}

enum MockGetHeroUseCaseError: Error {
	case generic
}
