//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by MAC on 26/06/2022.
//

import UIKit
import SDWebImage

class GenreCollectionViewCell: UICollectionViewCell {
    public static let identifier = "GenreCollectionViewCell"
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 30,
                weight: .regular))
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let genreLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private var colors: [UIColor] = [
        .systemRed,
        .systemPurple,
        .systemBlue,
        .systemPink,
        .systemGreen,
        .systemOrange
    ]
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemPurple
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(genreLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: contentView.width/2,
                                 y: 10,
                                 width: contentView.width/2,
                                 height: contentView.height/2)
        
        genreLabel.frame = CGRect(x: 10,
                                  y: contentView.height/2,
                                  width: contentView.width-20,
                                  height: contentView.height/2)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        genreLabel.text = ""
        imageView.image = nil
    }
    
    public func configure(with viewModel: CategoryViewModel) {
        genreLabel.text = viewModel.name
        imageView.sd_setImage(with: viewModel.artworkURL)
        contentView.backgroundColor = colors.randomElement()
    }
}
