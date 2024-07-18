//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 17.07.2024.
//

import UIKit
 final class SingleImageViewController: UIViewController {
   @IBOutlet var imageView: UIImageView!
     var image: UIImage?  {
         didSet {
             guard isViewLoaded else { return } // 1
             imageView.image = image // 2
         }
     }
     @IBAction private func didTapBackButton() {
            dismiss(animated: true, completion: nil)
        }
    
     
     override func viewDidLoad() {
             super.viewDidLoad()
             imageView.image = image
         }
    
}
