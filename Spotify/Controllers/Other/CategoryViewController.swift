//
//  CategoryViewController.swift
//  Spotify
//
//  Created by MAC on 26/06/2022.
//

import UIKit

class CategoryViewController: UIViewController {
    
    private var category: Category
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }


}
