//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 10.07.2024.
//


import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
   
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    public func configCell(_ tableView: UITableView, with indexPath: IndexPath, url: URL) {
        cellImage.kf.indicatorType = IndicatorType.activity
        cellImage.kf.setImage(with: url,
                              placeholder: UIImage(named: "Stub"),
                              options: []) { _ in
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
             //  cellImage.image = image
        dateLabel.text = dateFormatter.string(from: Date())
       
               let isLiked = indexPath.row % 2 == 0
               let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
               likeButton.setImage(likeImage, for: .normal)
    }
}
