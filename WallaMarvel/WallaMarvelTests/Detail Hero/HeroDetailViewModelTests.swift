//
//  HeroDetailViewModelTests.swift
//  WallaMarvel
//
//  Created by Diana Perez Afanador on 31/1/25.
//

import XCTest
import Combine
@testable import WallaMarvel

final class HeroDetailViewModelTests: XCTestCase {
	var viewModel: HeroDetailViewModel!
	var mockUseCase: MockGetHeroDetailUseCase!
	private var cancellables = Set<AnyCancellable>()

	override func setUp() {
		super.setUp()
		mockUseCase = MockGetHeroDetailUseCase()
		viewModel = HeroDetailViewModel(id: 1, getHeroDetailUseCase: mockUseCase)
	}

	override func tearDown() {
		mockUseCase = nil
		viewModel = nil
		super.tearDown()
	}

	func testInitialState() {
		XCTAssertNil(viewModel.hero, "Hero should initially be nil")
		XCTAssertFalse(viewModel.isLoading, "isLoading should initially be false")
		XCTAssertEqual(viewModel.errorMessage, "", "errorMessage should initially be empty")
		XCTAssertFalse(viewModel.showError, "showError should initially be false")
	}

	func testLoadHeroSuccesfully() {
		let mockHero = DetailCharacterDataModel(id: 1,
												name: "Spider-Man",
												description: "A superhero",
												modified: "", resourceURI: "",
												thumbnail: Thumbnail(path: "https://example.com/spiderman", extension: "jpg"),
												comics: ResourceList(available: 0, collectionURI: "", items: [], returned: 0),
												stories: ResourceList(available: 0, collectionURI: "", items: [], returned: 0),
												events: ResourceList(available: 0, collectionURI: "", items: [], returned: 0),
												series: ResourceList(available: 0, collectionURI: "", items: [], returned: 0))
		mockUseCase.mockHeroDetail = mockHero

		let expectation = expectation(description: "Hero details loaded successfully")
		viewModel.$hero
			.dropFirst()
			.sink { hero in
				XCTAssertNotNil(hero)
				XCTAssertEqual(hero?.name, "Spider-Man")
				expectation.fulfill()
			}
			.store(in: &cancellables)

		viewModel.loadCharacter()
		wait(for: [expectation], timeout: 2.0)
	}

	func testLoadHeroFailed() {
		mockUseCase.shouldReturnError = true

		let expectation = expectation(description: "Hero loading fails")
		viewModel.$showError
			.dropFirst()
			.sink { showError in
				XCTAssertTrue(showError)
				XCTAssertFalse(self.viewModel.errorMessage.isEmpty)
				expectation.fulfill()
			}
			.store(in: &cancellables)

		viewModel.loadCharacter()
		wait(for: [expectation], timeout: 2.0)
	}

	func testDismissError() {
		viewModel.errorMessage = "An error occurred"
		viewModel.showError = true

		viewModel.dismissError()

		XCTAssertEqual(viewModel.errorMessage, "")
		XCTAssertFalse(viewModel.showError)
	}
}
