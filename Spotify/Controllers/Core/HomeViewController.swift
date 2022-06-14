//
//  ViewController.swift
//  Spotify
//
//  Created by MAC on 14/06/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTappedSettingsItemBar))
        
        APICaller.shared.getNewReleases(completion: {result in
            switch result {
            case .success(let data):
                break
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        })
    }
    
    @objc private func didTappedSettingsItemBar() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

