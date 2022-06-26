//
//  TitleHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by MAC on 26/06/2022.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    public static let identifier = "TitleHeaderCollectionReusableView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 15, y: 0, width: width - 30, height: height)
    }
    
    public func configure(with title: String) {
        titleLabel.text = title
    }
}
