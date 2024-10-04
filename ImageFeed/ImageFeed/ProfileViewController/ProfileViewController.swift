//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 14.07.2024.
//


import UIKit
import Kingfisher



final class ProfileViewController: UIViewController {
    private let avatarImage: UIImageView = UIImageView()
       private let logoutButton: UIButton = UIButton()
       private let nameLabel: UILabel = configLabel(text: "Екатерина Новикова",
                                            font: UIFont.systemFont(ofSize: 23, weight: .semibold),
                                                    color: UIColor.white)
       private let loginNameLabel: UILabel = configLabel(text: "@ekaterina_nov",
                                                 font: UIFont.systemFont(ofSize: 13),
                                                         color: UIColor.gray)
       private let descriptionLabel: UILabel = configLabel(text: "Hello, World!",
                                                   font: UIFont.systemFont(ofSize: 13),
                                                           color: UIColor.white)
   
    private var profileImageServiceObserver: NSObjectProtocol?
    @IBAction private func didTapLogoutButton() {
    }
    let ProfileViewController = TabBarController.self
    
    private var label: UILabel?
    private let profileService = ProfileService.shared
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .color1
        
        updateProfileDetails(profile: profileService.profile ?? Profile(username: "", name: "", bio: ""))
        
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        
       
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
               let imageAvatar = UIImage(named: "avatar")
               avatarImage.image = imageAvatar

               logoutButton.translatesAutoresizingMaskIntoConstraints = false
               let imageButton = UIImage(named: "logout_button")
               logoutButton.setImage(imageButton, for: .normal)

               addAllSubviews()

               NSLayoutConstraint.activate([
                   avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
                   avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                   avatarImage.widthAnchor.constraint(equalToConstant: 70),
                   avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor, multiplier: 1.0),
                   nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
                   nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
                   nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                   loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                   loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
                   loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
                   descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
                   descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
                   descriptionLabel.trailingAnchor.constraint(equalTo: loginNameLabel.trailingAnchor),
                   logoutButton.widthAnchor.constraint(equalToConstant: 44),
                   logoutButton.heightAnchor.constraint(equalToConstant: 44),
                   logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
                   logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
               ])
        
       
       
        
//        _ = UIImage(systemName: "person.crop.circle.fill")
//        let imageView = UIImageView(image: UIImage(named: "Avatar"))
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(imageView)
//        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
//        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
//        
//        let nameLabel = UILabel()
//        nameLabel.text = "Екатерина Новикова"
//        nameLabel.textColor = .white
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(nameLabel)
//        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
//        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
//        //   self.nameLabel = nameLabel
//        
//        let logoutButton = UIButton.systemButton(
//            with: UIImage(systemName: "ipad.and.arrow.forward")!,
//            target: self,
//            action: #selector(Self.didTapButton)
//        )
//        logoutButton.tintColor = .red
//        logoutButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(logoutButton)
//        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
//        logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
//        
//        
//        let loginNameLabel = UILabel()
//        let descriptionLabel = UILabel()
//        
//        loginNameLabel.text = "@ekaterina_nov"
//        descriptionLabel.text = "Hello,World!"
//        
//        loginNameLabel.textColor = .gray
//        descriptionLabel.textColor = .white
//        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(loginNameLabel)
//        
//        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(descriptionLabel)
//        
//        NSLayoutConstraint.activate([
//            loginNameLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 25),
//            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
//            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 7),
//            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
//            
//        ])
        
        
       
        
    }
    
    func updateProfileDetails(profile: Profile) {
            nameLabel.text = profile.name
            loginNameLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        }
    
    private func updateAvatar() {
      guard
          let profileImageURL = ProfileImageService.shared.avatarURL,
          let url = URL(string: profileImageURL)
      else { return }
              // TODO [Sprint 11] Обновить аватар, используя Kingfisher
       let processor = RoundCornerImageProcessor(cornerRadius: 40)
       avatarImage.backgroundColor = .black
       avatarImage.tintColor = .black
       avatarImage.kf.setImage(with: url,
                             placeholder: UIImage(named: "placeholder.jpeg"),
                             options: [
                               .processor(processor),
                               .cacheSerializer(FormatIndicatedCacheSerializer.png)
                             ])
       
   }
    

    private static func configLabel(text: String, font: UIFont, color: UIColor) -> UILabel {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = text
           label.font = font
           label.textColor = color
           return label
       }

       private func addAllSubviews() {
           view.addSubview(avatarImage)
           view.addSubview(nameLabel)
           view.addSubview(loginNameLabel)
           view.addSubview(descriptionLabel)
           view.addSubview(logoutButton)
       }
    
    @objc
    private func didTapButton() {
        label?.removeFromSuperview()
        label = nil
        
        
    }
}

