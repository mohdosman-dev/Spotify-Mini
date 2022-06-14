//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by MAC on 14/06/2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        
        signInButton.addTarget(self, action: #selector(didTapedSignInButton), for: .touchUpInside)
        
        view.addSubview(signInButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signInButton.frame = CGRect(x: 20,
                                    y: view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width-40,
                                    height: 52)
    }
    
    @objc func didTapedSignInButton() {
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completionHandler = {[weak self] success in
            self?.handleSignIn(success: success)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        // Log user in or yell him for error
        guard success else {
            let alertController = UIAlertController(title: "Failed To Login",
                                                    message: "Cannot login to your account, Please try agian later",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss",
                                                    style: .cancel,
                                                   handler: nil))
            present(alertController, animated: true)
            return
        }
        
        let mainAppTabBar = TabBarViewController()
        mainAppTabBar.modalPresentationStyle = .fullScreen
        present(mainAppTabBar, animated: true)
    }
    
}
