//
//  GetHeroesTests.swift
//  WallaMarvel
//
//  Created by Diana Perez Afanador on 31/1/25.
//

import XCTest
@testable import WallaMarvel

final class GetHeroesTests: XCTestCase {
	var useCase: GetHeroes!
	var mockRepository: MockMarvelRepository!

	override func setUp() {
		super.setUp()
		mockRepository = MockMarvelRepository()
		useCase = GetHeroes(repository: mockRepository)
	}

	override func tearDown() {
		mockRepository = nil
		useCase = nil
		super.tearDown()
	}

	func testFetchData() {
		let mockHero1 = CharacterDataModel(id: 1, name: "Iron Man", thumbnail: Thumbnail(path: "https://example.com/ironman", extension: "jpg"))
		let mockHero2 = CharacterDataModel(id: 2, name: "Thor", thumbnail: Thumbnail(path: "https://example.com/thor", extension: "jpg"))
		mockRepository.mockHeros = [mockHero1, mockHero2]

		let expectation = expectation(description: "Fetch heroes successfully")
		useCase.execute(offset: 0, limit: 2) { result in
			switch result {
			case .success(let heroes):
				XCTAssertEqual(heroes.count, 2)
				XCTAssertEqual(heroes.first?.name, "Iron Man")
				XCTAssertEqual(heroes.last?.name, "Thor")
			case .failure:
				XCTFail("Expected success but got failure")
			}
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 2.0)
	}

	func testFetchDataError() {
		mockRepository.shouldReturnError = true

		let expectation = expectation(description: "Fetch heroes fails")
		useCase.execute(offset: 0, limit: 2) { result in
			switch result {
			case .success:
				XCTFail("Expected failure but got success")
			case .failure(let error):
				XCTAssertNotNil(error, "Expected an error but got nil")
			}
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 2.0)
	}

	func testFetchEmptyData() {
		mockRepository.mockHeros = []

		let expectation = expectation(description: "Fetch heroes but return empty list")
		useCase.execute(offset: 0, limit: 2) { result in
			switch result {
			case .success(let heroes):
				XCTAssertTrue(heroes.isEmpty, "Expected empty heroes list but got \(heroes.count) items")
			case .failure:
				XCTFail("Expected success but got failure")
			}
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 2.0)
	}
}
