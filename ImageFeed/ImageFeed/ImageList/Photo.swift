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
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let description: String?
    let altDescription: String?
    let likedByUser: Bool
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
