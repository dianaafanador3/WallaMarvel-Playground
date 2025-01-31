//
//  DetailHeroI.swift
//  WallaMarvel
//
//  Created by Diana Perez Afanador on 31/1/25.
//

import SwiftUI

struct DetailHeroUIModel: Identifiable {
	var id: Int
	var name: String
	var description: String
	var imageUrl: String
	var sections: [DetailSectionViewUIModel]
}

struct DetailSectionViewUIModel: Identifiable {
	var id: String {
		return title
	}
	var title: String
	var items: [String]
}

extension DetailHeroUIModel {
	static func from(_ model: DetailCharacterDataModel) -> DetailHeroUIModel {
		return DetailHeroUIModel(
			id: model.id,
			name: model.name,
			description: model.description,
			imageUrl: model.thumbnail.path + "/standard_fantastic." + model.thumbnail.extension,
			sections: [
				DetailSectionViewUIModel(title: "Comics", items: model.comics.items.map { $0.name }),
				DetailSectionViewUIModel(title: "Series", items: model.series.items.map { $0.name }),
				DetailSectionViewUIModel(title: "Events", items: model.events.items.map { $0.name }),
				DetailSectionViewUIModel(title: "Stories", items: model.stories.items.map { $0.name }),
			])
	}
}
