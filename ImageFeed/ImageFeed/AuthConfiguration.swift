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
    
    enum Photos {
           static let photosURLString: String = "https://api.unsplash.com/photos"
           static let perPage: Int = 10
       }
    enum Auth {
        static let authorizeURLString: String = "https://unsplash.com/oauth/authorize"
           static let defaultBaseURL: URL? = .init(string: "https://api.unsplash.com/")
       }
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    init(accessKey: String,
           secretKey: String,
           redirectURI: String,
           accessScope: String,
           authURLString: String,
           defaultBaseURL: URL
      )  {

        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }

    static var standard: AuthConfiguration {
        guard let baseURL = Constants.Auth.defaultBaseURL else {
            preconditionFailure("Wrong base URL")
        }
        return .init(
                   accessKey: Constants.accessKey,
                   secretKey: Constants.secretKey,
                   redirectURI: Constants.redirectURI,
                   accessScope: Constants.accessScope,
                   authURLString: Constants.Auth.authorizeURLString,
                   defaultBaseURL: baseURL
               )
    }
}
