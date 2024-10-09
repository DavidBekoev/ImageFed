//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 28.07.2024.
//

import UIKit
import ProgressHUD


protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    
    
    // MARK: - Private properties
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popToRootViewController(animated: true)
        ProgressHUD.animate()
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
          
            guard let self = self else { return }
            ProgressHUD.dismiss()
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                print("Actual token: \(token)")
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                debugPrint("[AuthViewController webViewViewController] \(error.localizedDescription)")
                vc.dismiss(animated: true)
                UIBlockingProgressHUD.dismiss()
                let alert = UIAlertController(title: "Что-то пошло не так",
                                              message: "Не удалось войти в систему",
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { _ in
                    alert.dismiss(animated: true)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}




