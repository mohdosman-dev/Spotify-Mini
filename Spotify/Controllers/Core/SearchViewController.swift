//
//  SearchViewController.swift
//  Spotify
//
//  Created by MAC on 14/06/2022.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    private let searchController: UISearchController = {
        let results = SearchResultsViewController()
        let controller = UISearchController(searchResultsController: results)
        controller.searchBar.placeholder = "Song, Artist or Album"
        controller.searchBar.searchBarStyle = .minimal
        controller.definesPresentationContext = true
        return controller
    }()
    
    private var categories = [CategoryViewModel]()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ in
                // Item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 2,
                    leading: 7,
                    bottom: 2,
                    trailing: 7)
                
                // Group
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(150)),
                    subitem: item,
                    count: 2)
                group.contentInsets = NSDirectionalEdgeInsets(
                    top: 10,
                    leading: 0,
                    bottom: 10,
                    trailing: 0)
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            }
        ))

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            GenreCollectionViewCell.self,
            forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func loadData() {
        APICaller.shared.getAvailableCategories { [weak self] result in
            switch result {
            case .success(let cat):
                DispatchQueue.main.async {
                    self?.categories = cat.categories.items.compactMap({
                        return CategoryViewModel(
                            name: $0.name,
                            artworkURL: URL(string: $0.icons.first?.url ?? ""))
                    })
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Cannot fetch categoreis: \(error)")
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultController = searchController.searchResultsUpdater as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        // TODO: Perform Search function
        //        APICaller.shared.search
    }

}

extension SearchViewController:  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GenreCollectionViewCell.identifier,
            for: indexPath) as? GenreCollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = categories[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // TODO: - Navigate to selected category
//        let category = categories
//        let vc = CategoryViewController(category: <#T##Category#>)
    }
    
}

