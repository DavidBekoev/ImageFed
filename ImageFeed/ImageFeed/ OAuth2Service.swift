//
//   OAuth2Service.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 07.08.2024.
//

import Foundation

final class OAuth2Service {
//    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
 //       completion(.success(""))
 //   }
    
    func fetchOAuthToken(code: String, completion: @escaping(_ result: Result<String, Error>) -> Void) {
         let request = makeOAuthTokenRequest (code: code) 
            let dataTask = URLSession.shared.data(for: request) { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                        completion(.success(responseBody.accessToken))
                    } catch {
                        completion(.failure(DecoderError.decodingError(error)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            dataTask.resume()
        }


    func makeOAuthTokenRequest(code: String) -> URLRequest {
         let baseURL = URL(string: "https://unsplash.com")!
         let url = URL(
             string: "/oauth/token"
             + "?client_id=\(accessKey)"
             + "&&client_secret=\(secretKey)"
             + "&&redirect_uri=\(redirectURI)"
             + "&&code=\(code)"
             + "&&grant_type=authorization_code",
             relativeTo: baseURL
         )!
      
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}

enum DecoderError: Error, LocalizedError {
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .decodingError(let error):
            return "Decoding error - \(error)"
        }
    }
}
