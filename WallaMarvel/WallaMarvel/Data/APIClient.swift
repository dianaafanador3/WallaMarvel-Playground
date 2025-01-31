import Foundation

protocol APIClientProtocol {
	func getHeroes(offset: Int, limit: Int, completionBlock: @escaping (Result<[CharacterDataModel], Error>) -> Void)
	func getHeroDetail(by id: Int, completionBlock: @escaping (Result<DetailCharacterDataModel, Error>) -> Void)
}

final class APIClient: APIClientProtocol {
    enum Constant {
        static let privateKey = ""
        static let publicKey = ""
    }

    init() { }

	private let baseUrl = "https://gateway.marvel.com:443/v1/public/"

	private func get<T: Decodable>(endPoint: String, offset: Int? = nil, limit: Int? = nil, completionBlock: @escaping (Result<T, Error>) -> Void) {
		let ts = String(Int(Date().timeIntervalSince1970))
		let privateKey = Constant.privateKey
		let publicKey = Constant.publicKey
		let hash = "\(ts)\(privateKey)\(publicKey)".md5
		var parameters: [String: String] = ["apikey": publicKey,
											"ts": ts,
											"hash": hash]

		if let offset,
		   let limit {
			parameters["offset"] = String(offset)
			parameters["limit"] = String(limit)
		}

		let urlString = baseUrl + endPoint
		var urlComponent = URLComponents(string: urlString)
		urlComponent?.queryItems = parameters.map { (key, value) in
			URLQueryItem(name: key, value: value)
		}

		let urlRequest = URLRequest(url: urlComponent!.url!)
		URLSession.shared.dataTask(with: urlRequest) { data, _, error in
			// Throw error if we get an error response
			if let error {
				completionBlock(Result<T, any Error>.failure(error))
				return
			}

			// Throw error if data is nil
			guard let data else {
				completionBlock(.failure(APIClientError.dataCorrupted))
				return
			}

			do {
				let dataModel = try JSONDecoder().decode(APIResponse<T>.self, from: data)
				completionBlock(.success(dataModel.result))
			} catch {
				// Throw error if data cannot be decoded
				completionBlock(.failure(error))
			}
		}.resume()
	}

	func getHeroes(offset: Int, limit: Int, completionBlock: @escaping (Result<[CharacterDataModel], Error>) -> Void) {
		return get(endPoint: "characters", offset: offset, limit: limit, completionBlock: completionBlock)
    }

	func getHeroDetail(by id: Int, completionBlock: @escaping (Result<DetailCharacterDataModel, Error>) -> Void) {
		get(endPoint: "characters/\(id)", completionBlock: { (result: Result<[DetailCharacterDataModel], Error>) in
			switch result {
			case .success(let heros):
				guard let hero = heros.first else {
					completionBlock(.failure(APIClientError.dataCorrupted))
					return
				}
				completionBlock(.success(hero))
			case .failure(let error):
				completionBlock(.failure(error))
			}
		})
	}
}

enum APIClientError: Error {
	case dataCorrupted
}
