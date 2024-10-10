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
    
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Constants.Token.storageKey)
        }
        set {
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
    func cleanToken() {
           let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: Constants.Token.storageKey)
           guard removeSuccessful else {
               preconditionFailure("Removing auth token was fail")
           }
       }
    
}
