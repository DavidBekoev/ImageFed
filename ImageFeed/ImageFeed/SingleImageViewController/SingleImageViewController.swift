//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 17.07.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet weak var backwardButton: UIButton!
    var fullImageURLString: String?
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else {
                debugPrint("[SingleImageViewController viewDidLoad] image is nil")
                return
            }
            
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
            imageView.accessibilityIdentifier = "full_image"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()
        setScales()
        backwardButton.accessibilityIdentifier = "nav_back_button"
    }
    
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard  let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        setScales()
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    private func setScales() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    private func loadImage() {
        UIBlockingProgressHUD.show()
        guard let fullImageURLString = fullImageURLString,
              let fullImageURL = URL(string: fullImageURLString)
        else {
            debugPrint("[SingleImageViewController viewDidLoad] image is nil")
            return
        }
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.image = imageResult.image
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: "Попробовать ещё раз?",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Не надо", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        let reload = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.loadImage()
        }
        alert.addAction(action)
        alert.addAction(reload)
        self.present(alert, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
