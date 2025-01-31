//
//  HeroDetailView.swift
//  WallaMarvel
//
//  Created by Diana Perez Afanador on 30/1/25.
//

import SwiftUI
import Foundation

struct HeroDetailView: View {
	@ObservedObject var viewModel: HeroDetailViewModelProtocol
	init(viewModel: HeroDetailViewModelProtocol) {
		self.viewModel = viewModel
	}

	var body: some View {
		VStack {
			if viewModel.isLoading {
				Text("Loading...").font(.headline)
			} else if let hero = viewModel.hero {
				ScrollView {

					VStack {
						URLImage(url: hero.imageUrl)
							.frame(width: 200, height: 200)
							.clipShape(RoundedRectangle(cornerRadius: 15))

						Text(hero.name)
							.font(.title)
							.bold()

						if !hero.description.isEmpty {
							Text(hero.description)
								.font(.body)
								.multilineTextAlignment(.center)
								.padding()
						} else {
							Text("No description available")
								.italic()
								.foregroundColor(.gray)
						}
					}
					.padding()
					ForEach(hero.sections) { section in
						SectionView(section: section)
					}
				}
			} else {
				Text("Character not found").foregroundColor(.red)
			}
		}
		.alert(isPresented: $viewModel.showError) {
			Alert(
				title: Text("Error"),
				message: Text(viewModel.errorMessage),
				dismissButton: .default(Text("OK")) {
					viewModel.dismissError()
				}
			)
		}
		.onAppear {
			viewModel.loadCharacter()
		}
	}
}

struct SectionView: View {
	let section: DetailSectionViewUIModel

	var body: some View {
		VStack(alignment: .leading, spacing: 5) {
			Text(section.title)
				.font(.headline)
				.padding(.top)
			let items = section.items.prefix(4)
			List(Array(items), id: \.self) { item in
				Text(item)
					.foregroundColor(.secondary)
			}
			.frame(height: CGFloat(items.count) * 44)
			.listStyle(PlainListStyle())
		}
		.padding(.horizontal)
	}
}

struct URLImage: View {
	let url: String

	@State private var image: UIImage?

	var body: some View {
		VStack {
			if let image = image {
				Image(uiImage: image)
					.resizable()
			}
		}
		.onAppear {
			loadImage()
		}
	}

	private func loadImage() {
		guard let imageURL = URL(string: url) else { return }
		URLSession.shared.dataTask(with: imageURL) { data, _, _ in
			guard let data = data,
				  let loadedImage = UIImage(data: data) else {
				return
			}
			DispatchQueue.main.async {
				self.image = loadedImage
			}
		}.resume()
	}
}
