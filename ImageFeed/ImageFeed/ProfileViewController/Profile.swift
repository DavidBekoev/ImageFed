//
//  Profile.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 11.09.2024.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    var loginName: String {
        return "@\(username)"
    }
    let bio: String?
}