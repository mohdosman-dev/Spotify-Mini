//
//  ProfileViewController.swift
//  Spotify
//
//  Created by MAC on 14/06/2022.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    private var models = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        getUserProfle()
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func getUserProfle() {
        APICaller.shared.getCurrentUserProfile(completion: {[weak self] result in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let model):
                    self?.updateUI(with:model)
                case .failure(let error):
                    print("Error is: \(error.localizedDescription)")
                    self?.failedToGetProfile()
                }
            }
        })
    }
    
    private func updateUI(with model: UserProfile) {
        tableView.isHidden = false
        
        // Configure table view model
        models.append(model.displayName)
        models.append(model.type)
        self.createTableHeader(with:model.images.first?.url)
        tableView.reloadData()
    }
    
    private func createTableHeader(with url:String?) {
        guard let urlString = url,
              let url = URL(string: urlString) else {
            return
        }
        
        let headerview = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.width,
                                              height: view.width / 1.5))
        let imageSize: CGFloat = headerview.height / 2
        let imageView = UIImageView(
            frame: CGRect(x: 0,
                          y: 0,
                          width: imageSize,
                          height: imageSize))
        headerview.addSubview(imageView)
        imageView.center = headerview.center
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageSize / 2
        imageView.layer.masksToBounds = true
        imageView.sd_setImage(with: url)
        tableView.tableHeaderView = headerview
        
    }
    
    private func failedToGetProfile() {
        let label = UILabel(frame: .zero)
        label.textColor = .secondaryLabel
        label.text = "Failed to get profile"
        label.sizeToFit()
        view.addSubview(label)
        label.center = view.center
    }
    
}

// MARK: - TableView
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
