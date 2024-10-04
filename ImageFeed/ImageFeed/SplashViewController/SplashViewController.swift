//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 08.08.2024.
//


import UIKit

final class SplashViewController: UIViewController {
    //  private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let logoImage: UIImageView = UIImageView()
    private let oAuth2Storage = OAuth2TokenStorage.shared
    //private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        let imageLogo = UIImage(named: "splash_screen_logo")
        logoImage.image = imageLogo
        
        view.addSubview(logoImage)
        
        NSLayoutConstraint.activate([
            logoImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 75),
            logoImage.heightAnchor.constraint(equalToConstant: 77)
        ])

     
            
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if let token = oAuth2Storage.token {
            debugPrint(token)
            fetchProfile(token)
            switchToTabBarController()
        } else {
            
            checkAuthenticationStatus()
            //
        }
        
    }
    
    //    super.viewWillAppear(animated)
    //    setNeedsStatusBarAppearanceUpdate()
        
   // }

  //  override var preferredStatusBarStyle: UIStatusBarStyle {
  //      .lightContent
  //  }
    

   
    private func checkAuthenticationStatus() {
    
        if oauth2TokenStorage.token != nil {
            loadUserInfoAndProceed()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard
                let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
                    
            else {
                assertionFailure ("failed init AuthViewController")
                return
            }
           
            authViewController.delegate = self
            authViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            present(authViewController, animated: true, completion: nil)
            
        }
    }
    
    private func loadUserInfoAndProceed() {
        switchToTabBarController()
    }
        
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
    }
    
}

    
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ authViewController: AuthViewController) {
        dismiss(animated: true) //{ [weak self] in
         //guard let self = self else { return }
         //self.switchToTabBarController()
        // }
        guard let token = oauth2TokenStorage.token else {
            return
        }
        fetchProfile(token)
        switchToTabBarController()
        UIBlockingProgressHUD.dismiss()
    }
    
    
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                debugPrint("[SplashViewController fetchProfile] Start loading avatar")
                              ProfileImageService.shared.fetchProfileImageURL(username: profileResult.username) { result in
                                   switch result {
                                   case .success(let avatarResult):
                                       debugPrint("[SplashViewController fetchProfile] Avatar loaded")
                                   case .failure(let error):
                                       debugPrint("[SplashViewController fetchProfile] Avatar loading failed\n \(error)")
                                   }
                               }
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                preconditionFailure("Profile loading failed\n \(error)")
            }
        }
        UIBlockingProgressHUD.dismiss()
    }
}
