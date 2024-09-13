//
//  OAuth2TokenStorage .swift
//  ImageFeed
//
//  Created by Давид Бекоев on 08.08.2024.
//

import Foundation
final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
       init() {}

       private let storage = UserDefaults.standard
       private enum StorageKeys: String {
           case token
       }

       var token: String? {
           get {
               storage.string(forKey: StorageKeys.token.rawValue)
           }
           set {
               storage.setValue(newValue, forKey: StorageKeys.token.rawValue)
           }
       }
   
}