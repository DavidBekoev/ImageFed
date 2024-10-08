//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 08.08.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let token: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
          case token = "access_token"
          case tokenType = "token_type"
          case scope = "scope"
          case createdAt = "created_at"
      }
}
