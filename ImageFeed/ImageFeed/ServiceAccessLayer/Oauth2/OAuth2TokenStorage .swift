//
//  OAuth2TokenStorage .swift
//  ImageFeed
//
//  Created by Давид Бекоев on 08.08.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
       init() {}

       private let storage = UserDefaults.standard
       private enum StorageKeys: String {
           case token
       }

       var token: String? {
           get {
               return KeychainWrapper.standard.string(forKey: Constants.Token.storageKey)
           }
           set {
               UserDefaults.standard.setValue(newValue, forKey: Constants.Token.storageKey)
                          if let newValue {
                              let isSuccess = KeychainWrapper.standard.set(newValue, forKey: Constants.Token.storageKey)
                              guard isSuccess else {
                                  preconditionFailure("Writing auth token was fail")
                              }
                          } else {
                              preconditionFailure("Writing auth token was fail: newValue is nil")
                          }

           }
       }
   
}
