//
//  HeroDetailViewModel.swift
//  WallaMarvel
//
//  Created by Diana Perez Afanador on 30/1/25.
//

import Foundation

// Abstract class
class HeroDetailViewModelProtocol: ObservableObject {
	@Published var hero: DetailHeroUIModel?
	@Published var isLoading = false
	@Published var errorMessage: String = ""
	@Published var showError: Bool = false

	func loadCharacter() {
		fatalError("Subclasses must implement `loadCharacter()`")
	}

	func dismissError() {
		fatalError("Subclasses must implement `dismissError()`")
	}
}

class HeroDetailViewModel: HeroDetailViewModelProtocol {
	private let id: Int
	private let getHeroDetailUseCase: GetHeroDetailUseCaseProtocol

	init(id: Int, getHeroDetailUseCase: GetHeroDetailUseCaseProtocol = GetHeroDetail()) {
		self.id = id
		self.getHeroDetailUseCase = getHeroDetailUseCase
	}

	override func loadCharacter() {
		isLoading = true
		getHeroDetailUseCase.execute(id: id) { [weak self] result in
			DispatchQueue.main.async {
				self?.isLoading = false
			}
			switch result {
			case .success(let heroDetail):
				DispatchQueue.main.async {
					let heroUIModel = DetailHeroUIModel.from(heroDetail)
					self?.hero = heroUIModel
				}
			case .failure(let error):
				self?.errorMessage = error.localizedDescription
				self?.showError = true
			}
		}
	}

	override func dismissError() {
		showError = false
		errorMessage = ""
	}
}
