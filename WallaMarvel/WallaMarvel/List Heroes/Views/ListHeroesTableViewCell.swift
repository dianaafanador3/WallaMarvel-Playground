import Foundation
import UIKit

final class ListHeroesTableViewCell: UITableViewCell {
	private let heroeImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private let heroeName: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		addSubviews()
		addContraints()
	}

	private func addSubviews() {
		addSubview(heroeImageView)
		addSubview(heroeName)
	}

	private func addContraints() {
		NSLayoutConstraint.activate([
			heroeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
			heroeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
			heroeImageView.heightAnchor.constraint(equalToConstant: 80),
			heroeImageView.widthAnchor.constraint(equalToConstant: 80),
			heroeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),

			heroeName.leadingAnchor.constraint(equalTo: heroeImageView.trailingAnchor, constant: 12),
			heroeName.topAnchor.constraint(equalTo: heroeImageView.topAnchor, constant: 8),
		])
	}

	func configure(model: HeroesUIModel) {
		if let url = URL(string: model.imageUrl) {
			URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
				guard let data = data,
					  let loadedImage = UIImage(data: data) else {
					print("Error: Could not load image")
					return
				}

				DispatchQueue.main.async {
					self?.heroeImageView.image = loadedImage
				}
			}.resume()
		}
		heroeName.text = model.name
	}
}
