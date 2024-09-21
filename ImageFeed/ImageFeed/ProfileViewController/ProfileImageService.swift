//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 17.09.2024.
//

import Foundation

final class ProfileImageService{
    
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private let oAuth2Storage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private init() {}
    
    
    
    func fetchProfileImageURL(username: String, _ handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
               if task != nil {
                   task?.cancel()
               }

               guard let request = getProfileRequest(username: username)
               else {
                   print("Invalid request")
                   handler(.failure(AuthServiceError.invalidRequest))
                   return
               }

        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
                   guard let self else { return }
            switch result {
            case .success(let body):
                self.avatarURL = body.profile_image.small
                handler(.success(body.profile_image.small))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": body.profile_image])
            
                   case .failure(let error):
                print("Invalid request/n \(error)")
                       handler(.failure(error))
                   }
               }
               self.task = task
               task.resume()
        
    }
    
    
    func getProfileRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            preconditionFailure("Unable to construct profile request")
                  }
                  var request = URLRequest(url: url)
                  guard let token = oAuth2Storage.token else {
                      preconditionFailure("Token is nil")
                  }
                  request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                  return request
              }
}



struct UserResult: Codable {
    let profile_image: AvatarUrls
}



struct AvatarUrls: Codable {
    let small: String
   }