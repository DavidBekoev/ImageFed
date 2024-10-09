//
//  Constans.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 27.07.2024.
//

import Foundation


enum Constants {
    static let accessKey: String = "Ut8DhbYDqB3IYd6F4ga5POG3n-GGbfe9JRuy_fexFcQ"
    static let secretKey: String = "e0KEcCLBvpNgA-PoxrJEgd59FMe7UDJpdhsR6-eLX5A"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    
    
    
    enum Profile {
        static let profileURLString: String = "https://api.unsplash.com/me"
        static let usersURLString: String = "https://api.unsplash.com/users/"
    }
    
    enum Token {
        static let grantType: String = "authorization_code"
        static let storageKey: String = "token"
        static let baseURLString: String =  "https://unsplash.com/oauth/token"
    }
    
}


