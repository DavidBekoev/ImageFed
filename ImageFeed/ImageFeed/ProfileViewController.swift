//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 14.07.2024.
//


import UIKit

final class ProfileViewController: UIViewController {
 //   @IBOutlet private var avatarImageView: UIImageView!
 //   @IBOutlet private var nameLabel: UILabel!
 //   @IBOutlet private var loginNameLabel: UILabel!
 //   @IBOutlet private var descriptionLabel: UILabel!

 //   @IBOutlet private var logoutButton: UIButton!

 //   @IBAction private func didTapLogoutButton() {
 //   }
    
    private var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        _ = UIImage(systemName: "person.crop.circle.fill")
        let imageView = UIImageView(image: UIImage(named: "Avatar"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
            //   self.nameLabel = nameLabel
        
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        logoutButton.tintColor = .red
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        
        let loginNameLabel = UILabel()
        let descriprionLabel = UILabel()
        
        loginNameLabel.text = "@ekaterina_nov"
        descriprionLabel.text = "Hello,World!"
    
        loginNameLabel.textColor = .gray
        descriprionLabel.textColor = .white
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        descriprionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriprionLabel)
        
        NSLayoutConstraint.activate([
            loginNameLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 25),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriprionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 7),
            descriprionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
          
        ])
        
    }
       @objc
        private func didTapButton() {
            label?.removeFromSuperview()
            label = nil
            
           
        }
    
}
