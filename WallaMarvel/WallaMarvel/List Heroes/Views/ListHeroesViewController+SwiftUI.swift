//
//  Untitled.swift
//  WallaMarvel
//
//  Created by Diana Perez Afanador on 30/1/25.
//

import SwiftUI

extension ListHeroesViewController {
	func navigateToHeroDetail(id: Int) {
		let useCase = GetHeroDetail()
		let viewModel = HeroDetailViewModel(id: id, getHeroDetailUseCase: useCase)
		let detailView = HeroDetailView(viewModel: viewModel)
		let hostingController = UIHostingController(rootView: detailView)
		self.navigationController?.pushViewController(hostingController, animated: true)
	}
}
