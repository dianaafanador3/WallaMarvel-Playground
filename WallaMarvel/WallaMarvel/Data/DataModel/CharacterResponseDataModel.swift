import Foundation

struct APIResponse<T: Decodable>: Decodable {
	let count: Int
	let limit: Int
	let offset: Int
	let result: T

	enum CodingKeys: String, CodingKey {
		case data
		case count, limit, offset, results
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
		self.count = try data.decode(Int.self, forKey: .count)
		self.limit = try data.decode(Int.self, forKey: .limit)
		self.offset = try data.decode(Int.self, forKey: .offset)
		self.result = try data.decode(T.self, forKey: .results)
	}
}
