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
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    weak var delegate: ImagesListCellDelegate?    
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
    
    
    
    public func configCell(_ tableView: UITableView, thumbImageURL: String, isLiked: Bool, created_at: Date?) {
        guard let url: URL = URL(string: thumbImageURL)
        else {
            debugPrint("[ImagesListCell configCell] Problem with URL \(thumbImageURL)")
            return
        }
        cellImage.kf.indicatorType = IndicatorType.activity
        cellImage.kf.setImage(with: url,
                              placeholder: UIImage(named: "Stub"),
                              options: []) { _ in
        }
        dateLabel.text = dateFormatter.string(for: created_at)
        setIsLiked(isLike: isLiked)
    }
    
    func setIsLiked(isLike: Bool) {
        if isLike {
            guard let likeOn = UIImage(named: "like_button_on") else { return }
            likeButton.imageView?.image = likeOn
        } else {
            guard let likeOff = UIImage(named: "like_button_off") else { return }
            likeButton.imageView?.image = likeOff
        }
    }
    
    @IBAction private func tapLikeButton() {
        delegate?.imageListCellDidTapLike(self)
    }
}
