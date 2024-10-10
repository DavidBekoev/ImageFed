//
//  Profile.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 11.09.2024.
//

import Foundation

struct Profile {
    let username: String
    let name: String?
    var loginName: String {
        return "@\(username)"
    }
    let bio: String?
}

struct UserResult: Codable {
    let profile_image: AvatarUrls
}

struct AvatarUrls: Codable {
    let small: String
    let medium: String
    let large: String
}

struct ProfileResult: Codable {
    let username: String
    let first_name: String?
    let last_name: String?
    let bio: String?
    
    
}
