//
//  Photo.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 09.10.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let created_at: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let created_at: String
    let description: String?
    let alt_description: String?
    let liked_by_user: Bool
    let width: Int
    let height: Int
    let urls: UrlsResult
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct LikeResult: Codable {
    let photo: PhotoResult
}
