import UIKit
import Combine
import SwiftUI

final class ListHeroesViewController: UIViewController {
	private var mainView: ListHeroesView { return view as! ListHeroesView  }
	private let searchController = UISearchController(searchResultsController: nil)
	private let loadingIndicator = UIActivityIndicatorView(style: .large)

	override func loadView() {
		view = ListHeroesView()
	}

	// Datasource
	private var heroes: [HeroesUIModel] = []
	private var cancellables: Set<AnyCancellable> = []

	private var viewModel: ListHeroesViewModelProtocol
	init(viewModel: ListHeroesViewModelProtocol) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		bindToModel()

		title = viewModel.title
		viewModel.loadHeros()
	}

	private func setupUI() {
		setUpTableView()
		setupSearchController()
		setupLoadingIndicator()
	}

	private func setUpTableView() {
		mainView.heroesTableView.delegate = self
		mainView.heroesTableView.dataSource = self
	}

	private func setupSearchController() {
		navigationItem.searchController = searchController
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Hero"
		definesPresentationContext = true
	}

	private func setupLoadingIndicator() {
		view.addSubview(loadingIndicator)
		loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}

	private func showErrorAlert(message: String) {
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: true)
	}

	// Subsribing to any changes in the view model publisher
	private func bindToModel() {
		viewModel.filteredHeroes
			.subscribe(on: DispatchQueue.global(qos: .userInitiated))
			.receive(on: DispatchQueue.main)
			.sink { [weak self] heroes in
				self?.heroes = heroes
				self?.mainView.heroesTableView.reloadData()
			}.store(in: &cancellables)

		viewModel.isLoading
			.subscribe(on: DispatchQueue.global(qos: .userInitiated))
			.receive(on: DispatchQueue.main)
			.sink { [weak self] isLoading in
				isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
			}.store(in: &cancellables)

		viewModel.errorMessage
			.receive(on: DispatchQueue.main)
			.sink { [weak self] errorMessage in
				if let message = errorMessage {
					self?.showErrorAlert(message: message)
				}
			}
			.store(in: &cancellables)
	}
}

extension ListHeroesViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let hero = heroes[indexPath.row]
		navigateToHeroDetail(id: hero.id)
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == heroes.count - 1 {
			viewModel.loadHeros()
		}
	}
}

extension ListHeroesViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		heroes.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ListHeroesTableViewCell", for: indexPath) as! ListHeroesTableViewCell
		let model = heroes[indexPath.row]
		cell.configure(model: model)
		return cell
	}
}

extension ListHeroesViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let query = searchController.searchBar.text ?? ""
		viewModel.filterHeroes(by: query)
	}
}
