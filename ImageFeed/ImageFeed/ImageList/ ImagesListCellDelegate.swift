//
//   ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 10.10.2024.
//
import Foundation
protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
