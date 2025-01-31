//
//  Untitled.swift
//  WallaMarvel
//
//  Created by Diana Perez Afanador on 31/1/25.
//

import XCTest
import Combine
@testable import WallaMarvel

final class ListHeroesViewModelTests: XCTestCase {
	var viewModel: ListHeroesViewModel!
	var mockUseCase: MockGetHeroesUseCase!
	private var cancellables = Set<AnyCancellable>()

	override func setUp() {
		super.setUp()
		mockUseCase = MockGetHeroesUseCase()
		viewModel = ListHeroesViewModel(getHeroesUseCase: mockUseCase)
	}

	override func tearDown() {
		mockUseCase = nil
		viewModel = nil
		super.tearDown()
	}

	func testInitialState() {
		XCTAssertEqual(viewModel.title, "List of Heroes")

		let expectation = expectation(description: "Initial state")
		viewModel.filteredHeroes
			.sink { heroes in
				XCTAssertEqual(heroes.count, 0)
				expectation.fulfill()
			}
			.store(in: &cancellables)

		wait(for: [expectation], timeout: 1.0)
	}

	func testLoadHeroesSuccessfully() {
		let mockHero1 = CharacterDataModel(id: 1, name: "Iron Man", thumbnail: Thumbnail(path: "https://example.com/ironman", extension: "jpg"))
		let mockHero2 = CharacterDataModel(id: 2, name: "Thor", thumbnail: Thumbnail(path: "https://example.com/thor", extension: "jpg"))
		mockUseCase.mockHeroes = [mockHero1, mockHero2]

		let expectation = expectation(description: "Heroes loaded successfully")
		viewModel.filteredHeroes
			.dropFirst()
			.sink { heroes in
				XCTAssertEqual(heroes.count, 2)
				XCTAssertEqual(heroes.first?.name, "Iron Man")
				XCTAssertEqual(heroes.last?.name, "Thor")
				expectation.fulfill()
			}
			.store(in: &cancellables)

		viewModel.loadHeros()
		wait(for: [expectation], timeout: 2.0)
	}

	func testLoadHeroesFailed() {
		mockUseCase.shouldReturnError = true

		let expectation = expectation(description: "Heroes loading failed")
		viewModel.errorMessage
			.dropFirst(2)
			.sink { errorMessage in
				XCTAssertNotNil(errorMessage)
				XCTAssertEqual(errorMessage, MockGetHeroUseCaseError.generic.localizedDescription)
				expectation.fulfill()
			}
			.store(in: &cancellables)

		viewModel.loadHeros()
		wait(for: [expectation], timeout: 2.0)
	}

	func testFilterHeroes() {
		let mockHero1 = CharacterDataModel(id: 1, name: "Iron Man", thumbnail: Thumbnail(path: "https://example.com/ironman", extension: "jpg"))
		let mockHero2 = CharacterDataModel(id: 2, name: "Thor", thumbnail: Thumbnail(path: "https://example.com/thor", extension: "jpg"))
		mockUseCase.mockHeroes = [mockHero1, mockHero2]

		viewModel.loadHeros()

		let expectation = expectation(description: "Heroes filtered successfully")
		viewModel.filteredHeroes
			.dropFirst()
			.sink { heroes in
				XCTAssertEqual(heroes.count, 1)
				XCTAssertEqual(heroes.first?.name, "Iron Man")
				expectation.fulfill()
			}
			.store(in: &cancellables)

		viewModel.filterHeroes(by: "Iron")
		wait(for: [expectation], timeout: 2.0)
	}

	func testLoadMoreHeroes() {
		let mockHero1 = CharacterDataModel(id: 1, name: "Spider-Man", thumbnail: Thumbnail(path: "https://example.com/spiderman", extension: "jpg"))
		let mockHero2 = CharacterDataModel(id: 2, name: "Iron Man", thumbnail: Thumbnail(path: "https://example.com/ironman", extension: "jpg"))
		let mockHero3 = CharacterDataModel(id: 3, name: "Hulk", thumbnail: Thumbnail(path: "https://example.com/hulk", extension: "jpg"))
		let mockHero4 = CharacterDataModel(id: 4, name: "Thor", thumbnail: Thumbnail(path: "https://example.com/thor", extension: "jpg"))

		mockUseCase.mockHeroes = [mockHero1, mockHero2]
		viewModel.loadHeros()

		mockUseCase.mockHeroes = [mockHero3, mockHero4]
		let expectation = expectation(description: "Pagination works correctly")
		viewModel.filteredHeroes
			.dropFirst()
			.sink { heroes in
				XCTAssertEqual(heroes.count, 4)
				XCTAssertEqual(heroes.first?.name, "Spider-Man")
				XCTAssertEqual(heroes.last?.name, "Thor")
				expectation.fulfill()
			}
			.store(in: &cancellables)

		viewModel.loadHeros()
		wait(for: [expectation], timeout: 2.0)
	}
}
