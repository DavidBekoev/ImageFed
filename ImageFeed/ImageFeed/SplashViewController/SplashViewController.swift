//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 08.08.2024.
//


import UIKit

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oAuth2Storage = OAuth2TokenStorage.shared
    //    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        if let token = oAuth2Storage.token {
                   fetchProfile(token)
                   switchToTabBarController()
        } else {
            
            checkAuthenticationStatus()
        }
    }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            setNeedsStatusBarAppearanceUpdate()
            
        }
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            .lightContent
        }
        
        private func checkAuthenticationStatus() {
            if let token = oauth2TokenStorage.token {
                loadUserInfoAndProceed()
            } else {
                performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
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
        }
        
    }

    
    extension SplashViewController {
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
                guard
                    let navigationController = segue.destination as? UINavigationController,
                    let viewController = navigationController.viewControllers.first as? AuthViewController
                else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)") }
                viewController.delegate = self
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }
    }


extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ authViewController: AuthViewController) {
        dismiss(animated: true) //{ [weak self] in
           // guard let self = self else { return }
           // self.switchToTabBarController()
            
            guard let token = oauth2TokenStorage.token else {
                return
            }
            fetchProfile(token)
            switchToTabBarController()
            UIBlockingProgressHUD.dismiss()
        }
    

        
         func fetchProfile(_ token: String) {
            UIBlockingProgressHUD.show()
            profileService.fetchProfile{ [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                case .failure(_):
                    preconditionFailure("Profile loading failed")
                }
            }
            UIBlockingProgressHUD.dismiss()
        }
        
    }

