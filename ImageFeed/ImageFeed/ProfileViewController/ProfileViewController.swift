//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 14.07.2024.
//


import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func setProfileInfo(name: String?, login: String, bio: String?)
    func updateAvatar(url: URL?)
}


final class ProfileViewController: UIViewController {
    var presenter: ProfilePresenterProtocol?
    private let oAuth2Storage = OAuth2TokenStorage.shared
    private let avatarImage: UIImageView = UIImageView()
    private let logoutButton: UIButton = UIButton()
//     let nameLabel: UILabel = configLabel(text: "Екатерина Новикова",
//                                                 font: UIFont.systemFont(ofSize: 23, weight: .semibold),
//                                                 color: UIColor.white)
//     let loginNameLabel: UILabel = configLabel(text: "@ekaterina_nov",
//                                                      font: UIFont.systemFont(ofSize: 13),
//                                                      color: UIColor.gray)
//     let descriptionLabel: UILabel = configLabel(text: "Hello, World!",
//                                                        font: UIFont.systemFont(ofSize: 13),
//                                                        color: UIColor.white)
    
    let nameLabel: UILabel = configLabel(font: UIFont.systemFont(ofSize: 23, weight: .semibold),
                                            color: .white)
       let loginNameLabel: UILabel = configLabel(font: UIFont.systemFont(ofSize: 13),
                                                 color: .gray)
       let descriptionLabel: UILabel = configLabel(font: UIFont.systemFont(ofSize: 13),
                                                   color: .white)
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileServiceObserver: NSObjectProtocol?
    @IBAction private func didTapLogoutButton() {
    }
    let ProfileViewController = TabBarController.self
    private var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .color1
        
        updateAvatar(url: presenter?.avatarURL())
        presenter?.viewDidLoad()
        
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar(url: presenter?.avatarURL())
            }
        
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        let imageButton = UIImage(named: "Logout")
        logoutButton.setImage(imageButton, for: .normal)
        logoutButton.addTarget(self, action: #selector(tapLogoutButton), for: UIControl.Event.touchUpInside)
        logoutButton.accessibilityIdentifier = "logoutButton"
        
        addAllSubviews()
        addConstraints()
    }
    
    private func addConstraints() {
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
        
    }
    
    
    private static func configLabel(font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
  //      label.text = text
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
    
    @objc private func tapLogoutButton() {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены что хотите выйти?",
                                      preferredStyle: .alert)
        let yes = UIAlertAction(title: "Да", style: .default) { [weak self] _ in          guard let self = self else { return }
            self.presenter?.logout()
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        }
        let no = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(yes)
        alert.addAction(no)
        yes.accessibilityIdentifier = "yesAlertButton"
        no.accessibilityIdentifier = "noAlertButton"
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func didTapButton() {
        label?.removeFromSuperview()
        label = nil
        
        
    }
    
}

extension ProfileViewController: ProfileViewControllerProtocol {
    func setProfileInfo(name: String?, login: String, bio: String?) {
        nameLabel.text = name
        loginNameLabel.text = login
        descriptionLabel.text = bio
    }
    
    func updateAvatar(url: URL?) {
        guard let url else {
            debugPrint("[ProfileViewController updateAvatar] No avatar url")
            return
        }
        let processor = RoundCornerImageProcessor(cornerRadius: 80)
        avatarImage.backgroundColor = .color1
        avatarImage.tintColor = .black
        avatarImage.kf.indicatorType = IndicatorType.activity
        avatarImage.kf.setImage(with: url,
                                placeholder: UIImage(named: "placeholder"),
                                options: [
                                    .processor(processor),
                                    .cacheSerializer(FormatIndicatedCacheSerializer.png)
                                ]) { _ in
                                    debugPrint("Avatar installed")
                                }
    }
}
