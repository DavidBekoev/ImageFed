//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 11.10.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    let oAuth2Storage = OAuth2TokenStorage.shared
    let profileService = ProfileService.shared
    let profileImageService = ProfileImageService.shared
    let imageListService = ImagesListService.shared
    
    private init() { }
    
    func logout() {
        cleanCookies()
        oAuth2Storage.cleanToken()
        profileService.cleanProfile()
        profileImageService.cleanAvatar()
        imageListService.cleanImages()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
