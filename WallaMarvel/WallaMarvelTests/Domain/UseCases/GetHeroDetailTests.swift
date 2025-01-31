//
//  Untitled.swift
//  WallaMarvel
//
//  Created by Diana Perez Afanador on 31/1/25.
//

import XCTest
@testable import WallaMarvel

final class GetHeroDetailTests: XCTestCase {
	var useCase: GetHeroDetail!
	var mockRepository: MockMarvelRepository!

	override func setUp() {
		super.setUp()
		mockRepository = MockMarvelRepository()
		useCase = GetHeroDetail(repository: mockRepository)
	}

	override func tearDown() {
		mockRepository = nil
		useCase = nil
		super.tearDown()
	}

	func testFetchData() {
		let mockHero = DetailCharacterDataModel(id: 1,
												name: "Spider-Man",
												description: "A superhero",
												modified: "", resourceURI: "",
												thumbnail: Thumbnail(path: "https://example.com/spiderman", extension: "jpg"),
												comics: ResourceList(available: 0, collectionURI: "", items: [], returned: 0),
												stories: ResourceList(available: 0, collectionURI: "", items: [], returned: 0),
												events: ResourceList(available: 0, collectionURI: "", items: [], returned: 0),
												series: ResourceList(available: 0, collectionURI: "", items: [], returned: 0))
		mockRepository.mockHeroDetail = mockHero

		let expectation = expectation(description: "Fetch hero detail successfully")
		useCase.execute(id: 1) { result in
			switch result {
			case .success(let hero):
				XCTAssertEqual(hero.id, mockHero.id)
				XCTAssertEqual(hero.name, mockHero.name)
				XCTAssertEqual(hero.description, mockHero.description)
				XCTAssertEqual(hero.thumbnail.path, "https://example.com/spiderman")
				XCTAssertEqual(hero.thumbnail.extension, "jpg")
				XCTAssertEqual(hero.thumbnail.extension, "jpg")
			case .failure:
				XCTFail("Expected success but got failure")
			}
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 2.0)
	}

	func testFetchDataError() {
		mockRepository.shouldReturnError = true

		let expectation = expectation(description: "Fetch hero detail fails")
		useCase.execute(id: 1) { result in
			switch result {
			case .success:
				XCTFail("Should not happen")
			case .failure(let error):
				XCTAssertNotNil(error, "Expected an error but got nil")
			}
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 2.0)
	}
}
