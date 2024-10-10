//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 10.09.2024.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private let oAuth2Storage = OAuth2TokenStorage.shared
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    
    
    private init() {}
    
    
    func fetchProfile(handler: @escaping(_ result: Result<ProfileResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            return
        }
        
        guard let request = getProfileRequest()
        else {
            debugPrint("[ProfileService fetchProfile] Invalid request")
            handler(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            switch result {
                
            case .success(let body):
                self.profile = convert(profileResult: body)
                handler(.success(body))
                
                
                
                
            case .failure(let error):
                debugPrint("[ProfileService fetchProfile] Invalid request/n \(error)")
                handler(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    
    func getProfileRequest() -> URLRequest? {
        guard let url = URL(string: Constants.Profile.profileURLString) else {
            
            preconditionFailure("Unable to construct profile request")
        }
        var request = URLRequest(url: url)
        guard let token = oAuth2Storage.token else {
            preconditionFailure("Token is nil")
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func convert(profileResult: ProfileResult) -> Profile {
        return Profile(
            username: profileResult.username,
            name: "\(profileResult.first_name ?? "") \(profileResult.last_name ?? "")",
            bio: profileResult.bio)
    }
}




