//
//  ListHeroesViewModel.swift
//  WallaMarvel
//
//  Created by Diana Perez Afanador on 30/1/25.
//

import Combine
import Foundation

protocol ListHeroesViewModelProtocol {
	var title: String { get }
	var filteredHeroes: Published<[HeroesUIModel]>.Publisher { get }
	var isLoading: Published<Bool>.Publisher { get }
	var errorMessage: Published<String?>.Publisher { get }

	func loadHeros()
	func filterHeroes(by text: String)
}

class ListHeroesViewModel: ListHeroesViewModelProtocol {
	var title: String = "List of Heroes"
	var filteredHeroes: Published<[HeroesUIModel]>.Publisher {
		$_filteredHeroes
	}
	var isLoading: Published<Bool>.Publisher {
		$_isLoading
	}
	var errorMessage: Published<String?>.Publisher {
		$_errorMessage
	}

	@Published private var _filteredHeroes: [HeroesUIModel] = []
	@Published private var _isLoading: Bool = false
	@Published private var _errorMessage: String?
	private let limit = 20
	private var currentOffset = 0
	private var heroes: [HeroesUIModel] = []
	private var isSearching: Bool = false

	private let getHeroesUseCase: GetHeroesUseCaseProtocol
	init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes()) {
		self.getHeroesUseCase = getHeroesUseCase
	}

	func loadHeros() {
		guard !_isLoading,
			  !isSearching else {
			print("Already loadin or searching")
			return
		}

		_isLoading = true
		_errorMessage = nil
		getHeroesUseCase.execute(offset: currentOffset, limit: limit) { [weak self] result in
			guard let self else { return }
			self._isLoading = false
			switch result {
			case .success(let newHeros):
				self.heroes.append(contentsOf: newHeros.map(HeroesUIModel.from))
				self.currentOffset += self.limit
				self._filteredHeroes = heroes
			case .failure(let error):
				self._errorMessage = error.localizedDescription
			}
		}
	}

	func filterHeroes(by text: String) {
		let isSearching = !text.isEmpty
		self.isSearching = isSearching

		let filteredList = isSearching
		? heroes.filter { $0.name.lowercased().contains(text.lowercased()) }
		: heroes
		_filteredHeroes = filteredList
	}
}
