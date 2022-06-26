//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by MAC on 26/06/2022.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    public static let identifier = "PlaylistHeaderCollectionReusableView"
    
    var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton: UIButton = {
       let button = UIButton()
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        let image = UIImage(
            systemName: "play.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 24,
                weight: UIImage.SymbolWeight.regular
            )
        )
        button.setImage(image, for: .normal)
        return button
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(playlistImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        
        playAllButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func didTapPlay() {
        // TODO: Implement play all using deleage
        self.delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = height / 1.8
        
        playlistImageView.frame = CGRect(
            x: (width-imageSize)/2,
            y: 20,
            width: imageSize,
            height: imageSize
        )
        
        nameLabel.frame = CGRect(
            x: 10,
            y: playlistImageView.bottom + 4,
            width: width,
            height: 30
        )
        
        descriptionLabel.frame = CGRect(
            x: 10,
            y: nameLabel.bottom + 4,
            width: width,
            height: 30
        )
        
        ownerLabel.frame = CGRect(
            x: 10,
            y: descriptionLabel.bottom + 4,
            width: width,
            height: 30
        )
        
        playAllButton.frame = CGRect(x: width - 80, y: height - 80, width: 60, height: 60)
        
    }
    
    public func configure(with viewModel: PlaylistHeaderViewModel) {
        playlistImageView.sd_setImage(with: viewModel.imageURL)
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        ownerLabel.text = viewModel.owner
    }
}
