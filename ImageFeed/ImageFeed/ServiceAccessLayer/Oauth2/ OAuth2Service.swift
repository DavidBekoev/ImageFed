//
//   OAuth2Service.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 07.08.2024.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?                       
    private var lastCode: String?
    private init() {}
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents?.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {                                    // 5
            if lastCode != code {                           // 6
                task?.cancel()                              // 7
            } else {
                debugPrint("[OAuth2Service fetchOAuthToken] Invalid request")
                completion(.failure(AuthServiceError.invalidRequest))
                return                                      // 8
            }
        } else {
            if lastCode == code {
                debugPrint("[OAuth2Service fetchOAuthToken] Invalid request")
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code                                     // 10
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            debugPrint("[OAuth2Service fetchOAuthToken] Invalid request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            switch result {
            case .success(let body):
                           completion(.success(body.accessToken))
            case .failure(let error):
                debugPrint("[OAuth2Service fetchOAuthToken] Invalid request/n \(error)")
                completion(.failure(error))
            }
            self.task = nil
            self.lastCode = nil
        }
        
        self.task = task
        task.resume()
        
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





