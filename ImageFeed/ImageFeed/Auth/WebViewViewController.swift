//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 28.07.2024.
//
import UIKit
@preconcurrency import WebKit

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}



fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol{
    var presenter: WebViewPresenterProtocol?
    @IBOutlet var webView: WKWebView!
    @IBAction  func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    @IBOutlet private var progressView: UIProgressView!
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 presenter?.didUpdateProgressValue(webView.estimatedProgress)
             })
        webView.accessibilityIdentifier = "UnsplashWebView"
        
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        UIBlockingProgressHUD.show()
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
            dismiss(animated: true)
            
        } else {
            decisionHandler(.allow)
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        debugPrint("[WebViewViewController code] No code found in navigation action")
        return nil
    }
}
