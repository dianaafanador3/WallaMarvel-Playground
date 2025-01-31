import Foundation

struct CharacterDataModel: Decodable {
	let id: Int
	let name: String
	let thumbnail: Thumbnail
}

struct DetailCharacterDataModel: Decodable {
    let id: Int
    let name: String
	let description: String
	let modified: String
	let resourceURI: String
    let thumbnail: Thumbnail
	let comics: ResourceList
	let stories: ResourceList
	let events: ResourceList
	let series: ResourceList
}

struct ResourceList: Codable {
	let available: Int
	let collectionURI: String
	let items: [ResourceSummary]
	let returned: Int
}

struct ResourceSummary: Codable, Identifiable {
	var id: String {
		return resourceURI
	}

	let resourceURI: String
	let name: String
}
