//
//  ViewController.swift
//  Spotify
//
//  Created by MAC on 14/06/2022.
//

import UIKit


enum BrowseSectionType {
    case newReleases(viewModel: [NewReleasesCellViewModel])
    case featuredPlaylist(viewModel: [FeaturedPlaylistCellViewModel])
    case recommendedTracks(viewModel: [RecommendedTrackCellViewModel])
    
    var title: String {
        switch self {
            
        case .newReleases:
            return "New Releases"
        case .featuredPlaylist:
            return "Featured Playlists"
        case .recommendedTracks:
            return "Recommeneded Tracks For You"
        }
    }
}

class HomeViewController: UIViewController {
    
    
    private var albums: [Album] = []
    private var featured: [Playlist] = []
    private var recommendedTracks: [AudioTrack] = []
    
    private var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return createLayout(section: sectionIndex)
        })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [BrowseSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTappedSettingsItemBar))
        configureCollectionView()
        view.addSubview(spinner)
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        // New Release Cell
        collectionView.register(
            NewReleaseCollectionViewCell.self,
            forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        
        // Featured Playlist Cell
        collectionView.register(
            FeaturedPlaylistCollectionViewCell.self,
            forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        
        // Recommended Tracks Cell
        collectionView.register(
            RecommendedTracksCollectionViewCell.self,
            forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier)
        
        // Title for each section
        collectionView.register(
            TitleHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
    func loadData() {
        let group = DispatchGroup()
        
        group.enter()
        group.enter()
        group.enter()
        
        print("Start fetching data...")
        
        var newRelease: NewReleaseResponse?
        var featuredPlaylist: FeaturedResponse?
        var recommened: RecommendationResponse?
        
        // Get New Releases
        APICaller.shared.getNewReleases(completion: { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                newRelease = model
            case .failure(let error):
                print("Error while fetch new releases: \(error)")
            }
        })
        
        // Get Featured Playlists
        APICaller.shared.getFeaturedPlaylist(completion: { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                featuredPlaylist = model
            case .failure(let error):
                print("Error while fetch featured playlist: \(error)")
            }
        })
        
        // Get Recommeded Tracks
        APICaller.shared.getAvailableGenre(completion: {result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                
                APICaller.shared.getRecommendations(genres: seeds,
                                                    completion: {result2 in
                    defer {
                        group.leave()
                    }
                    switch result2 {
                    case .success(let model):
                        recommened = model
                    case .failure(let error):
                        print("Error while fetch recommended tracks: \(error)")
                    }
                })
                
            case .failure(let error):
                print("Error is: \(error)")
            }
        })
        
        // Watch group if finished
        group.notify(queue: .main) { [weak self] in
            guard let newAlbums = newRelease?.albums.items,
                  let featured = featuredPlaylist?.playlists.items,
                  let recommendations = recommened?.tracks else {
                fatalError("The models are nil")
                return
            }
            print("Data fetched successfully")
            self?.configureViewModel(
                albums: newAlbums,
                featured: featured,
                recommendedTracks: recommendations
            )
        }
        
    }
    
    
    private func configureViewModel(
        albums: [Album],
        featured: [Playlist],
        recommendedTracks: [AudioTrack]
    ) {
        
        // Append to self
        self.albums = albums
        self.featured = featured
        self.recommendedTracks = recommendedTracks
        
        // Configure sections data
        sections.append(.newReleases(viewModel: albums.compactMap({
            return NewReleasesCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.totalTracks,
                artistName: $0.artists.first?.name ?? "-")
        })))
        sections.append(.featuredPlaylist(viewModel: featured.compactMap({
            return FeaturedPlaylistCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                creatorName: $0.owner.displayName
            )
        })))
        sections.append(.recommendedTracks(viewModel: recommendedTracks.compactMap({
            return RecommendedTrackCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.album?.images.first?.url ?? ""),
                artistName: $0.artists.first?.name ?? "-"
            )
        })))
        collectionView.reloadData()
    }
    
    @objc private func didTappedSettingsItemBar() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
            
        case .newReleases(viewModel: let viewModel):
            return viewModel.count
        case .featuredPlaylist(viewModel: let viewModel):
            return viewModel.count
        case .recommendedTracks(viewModel: let viewModel):
            return viewModel.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section {
        case .newReleases:
            let album = self.albums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = album.name
            navigationController?.pushViewController(vc, animated: true)
        case .featuredPlaylist:
            let playlist = self.featured[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = playlist.name
            navigationController?.pushViewController(vc, animated: true)
            break
        case .recommendedTracks:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        // Return new realses cell
        case .newReleases(viewModel: let models):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                for: indexPath
            ) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = models[indexPath.row]
            cell.backgroundColor = .systemRed
            cell.configure(with: viewModel)
            return cell
            
        // Return featured playlist cell
        case .featuredPlaylist(viewModel: let models):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                for: indexPath
            ) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = models[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        // Return recommended tracks cell
        case .recommendedTracks(viewModel: let models):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier,
                for: indexPath
            ) as? RecommendedTracksCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = models[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
                for: indexPath
              ) as? TitleHeaderCollectionReusableView else  {
            return UICollectionReusableView()
        }
        let headerTitle = sections[indexPath.section]
        header.configure(with: headerTitle.title)
        
        return header
    }
    
    
    static func createLayout(section: Int) -> NSCollectionLayoutSection {
        let header = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        switch section {
        case 0:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.9)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2)
            
            // Group
            let vGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)),
                subitem: item,
                count: 3)
            
            
            let hGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)),
                subitem: vGroup,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection.init(group: hGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = header
            
            return section
        case 1:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2)
            
            let vGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(300)),
                subitem: item,
                count: 2)
            
            
            let hGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(300)),
                subitem: vGroup,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection.init(group: hGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = header
            return section
        case 2:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2)
            
            // Group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(60)),
                subitem: item,
                count: 1)
            
            
            // Section
            let section = NSCollectionLayoutSection.init(group: group)
            section.boundarySupplementaryItems = header
            return section
        default:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.9)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2)
            
            // Group
            let vGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)),
                subitem: item,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection.init(group: vGroup)
            section.boundarySupplementaryItems = header
            return section
        }
    }
}
