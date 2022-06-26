//
//  AlbumsViewController.swift
//  Spotify
//
//  Created by MAC on 18/06/2022.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private var album: Album
    
    
    private var tracks = [RecommendedTrackCellViewModel]()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ in
                // Item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 4,
                                                             leading: 4,
                                                             bottom: 4,
                                                             trailing: 4)
                
                // Group
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(70)),
                    subitem: item,
                    count: 1)
                
                
                // Section
                let section = NSCollectionLayoutSection.init(group: group)
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalHeight(0.5)
                        ),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                ]
                return section
            })
    )
    
    init(album: Album) {
        
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title  = self.album.name
        
        
        collectionView.register(
            RecommendedTracksCollectionViewCell.self,
            forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier)
        collectionView.register(
            PlaylistHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        
        view.addSubview(collectionView)
        
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func loadData() {
        APICaller.shared.getAlbumDetails(for: self.album) {[weak self] result in
            switch result {
            case .success(let albumResponse):
                DispatchQueue.main.async {
                    self?.tracks = albumResponse.tracks.items.compactMap({
                        return RecommendedTrackCellViewModel(
                            name: $0.name,
                            artworkURL: URL(string: self?.album.images.first?.url ?? ""),
                            artistName: $0.artists.first?.name ?? "-")
                    })
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier,
            for: indexPath) as? RecommendedTracksCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = tracks[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier, for: indexPath
              ) as? PlaylistHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        let viewModel = PlaylistHeaderViewModel(
            name: album.name,
            description: "Release Date: \(String.formattedDate(dateString: album.releaseDate))",
            owner: album.artists.first?.name ?? "-",
            imageURL: URL(string: album.images.first?.url ?? "")
        )
        header.delegate = self
        header.configure(with: viewModel)
        return header
    }
}

extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        print("Play all songs in album")
    }
}
