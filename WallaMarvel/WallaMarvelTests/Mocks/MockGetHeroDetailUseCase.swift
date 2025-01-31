//
//  MockGetHeroDetailUseCase.swift
//  WallaMarvel
//
//  Created by Diana Perez Afanador on 31/1/25.
//

@testable import WallaMarvel

class MockGetHeroDetailUseCase: GetHeroDetailUseCaseProtocol {
	var shouldReturnError = false
	var mockHeroDetail: DetailCharacterDataModel?

	func execute(id: Int, completionBlock: @escaping (Result<DetailCharacterDataModel, Error>) -> Void) {
		if shouldReturnError {
			completionBlock(.failure(MockGetHeroDetailUseCaseError.generic))
		} else if let mockHeroDetail = mockHeroDetail {
			completionBlock(.success(mockHeroDetail))
		}
	}
}

enum MockGetHeroDetailUseCaseError: Error {
	case generic
}
