//
//  Heroes.swift
//  WallaMarvel
//
//  Created by Diana Perez Afanador on 31/1/25.
//

struct HeroesUIModel {
	var id: Int
	var name: String
	var imageUrl: String
}

extension HeroesUIModel {
	static func from(_ model: CharacterDataModel) -> HeroesUIModel {
		return HeroesUIModel(
			id: model.id,
			name: model.name,
			imageUrl: model.thumbnail.path + "/portrait_small." + model.thumbnail.extension)
	}
}
