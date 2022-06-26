//
//  AlbumsViewController.swift
//  Spotify
//
//  Created by MAC on 18/06/2022.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private var album: Album
    
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
        
        loadData()
    }
    
    private func loadData() {
        APICaller.shared.getAlbumDetails(for: self.album) { _ in
            
        }
    }
}
