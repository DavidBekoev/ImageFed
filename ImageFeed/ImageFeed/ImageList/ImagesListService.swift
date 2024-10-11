//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 09.10.2024.
//

import Foundation

final class ImagesListService {
    private(set) var photos: [Photo] = []
    static let shared = ImagesListService()
    private var lastLoadedPage: Int = 0
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let oAuth2Storage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private var likeTask: URLSessionTask?
    private lazy var dateFormatter: ISO8601DateFormatter = {
            return ISO8601DateFormatter()
        }()
    private init() {}
    
    
    func fetchPhotosNextPage(handler: @escaping(_ result: Result<[PhotoResult], Error>) -> Void) {
        let nextPage = lastLoadedPage + 1
        assert(Thread.isMainThread)
        if task != nil {
            return
        }
        
        guard let request = getPhotosRequest(page: nextPage)
        else {
            debugPrint("[ImagesListService fetchPhotosNextPage] Invalid request")
            handler(.failure(AuthServiceError.invalidRequest))
            return
        }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            switch result {
            case .success(let body):
                self.photos.append(contentsOf: convert(photoResult: body))
                handler(.success(body))
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["Photos": body])
            case .failure(let error):
                debugPrint("[ImagesListService fetchPhotosNextPage] Invalid request/n \(error)")
                handler(.failure(error))
            }
            self.task = nil
        }
        lastLoadedPage += 1
        self.task = task
        task.resume()
    }
    
    func getPhotosRequest(page: Int) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.Photos.photosURLString)
        else {
            debugPrint("[ImagesListService getPhotosRequest] baseURLString is nil")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(Constants.Photos.perPage)")
        ]
        guard let url = urlComponents.url
        else {
            debugPrint("[ImagesListService getPhotosRequest] url is nil")
            return nil
        }
        var request = URLRequest(url: url)
        guard let token = oAuth2Storage.token else {
            preconditionFailure("Token is nil")
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func convert(photoResult: [PhotoResult]) -> [Photo] {
        var photosResult: [Photo] = []
        for photo in photoResult {
            photosResult.append(
                Photo(
                    id: photo.id,
                    size: CGSize(width: photo.width, height: photo.height),
                    created_at: dateFormatter.date(from: photo.created_at),
                    welcomeDescription: photo.alt_description,
                    thumbImageURL: photo.urls.small,
                    largeImageURL: photo.urls.full,
                    isLiked: photo.liked_by_user
                )
            )
            
        }
        return photosResult
    }
    
    func cleanImages() {
           photos.removeAll()
           lastLoadedPage = 0
       }
    

    
    func changeLike(photoId: String, isLike: Bool, _ handler: @escaping (Result<LikeResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        if likeTask != nil {
            return
        }
        
        guard let request = getLikeRequest(isLike: isLike, photoId: photoId)
        else {
            debugPrint("[ImagesListService changeLike] Invalid request")
            handler(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let likeTask = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let body):
                handler(.success(body))
            case .failure(let error):
                debugPrint("[ImagesListService changeLike] Invalid request/n \(error)")
                handler(.failure(error))
            }
            self.likeTask = nil
        }
        self.likeTask = likeTask
        likeTask.resume()
    }
    
    func getLikeRequest(isLike: Bool, photoId: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "\(Constants.Photos.photosURLString)/\(photoId)/like")
        else {
            debugPrint("[ImagesListService getLikeRequest] photosURLString is nil")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        guard let url = urlComponents.url
        else {
            debugPrint("[ImagesListService getLikeRequest] url is nil")
            return nil
        }
        var request = URLRequest(url: url)
        guard let token = oAuth2Storage.token else {
            preconditionFailure("Token is nil")
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if isLike { request.httpMethod = "POST" }
        else { request.httpMethod = "DELETE" }
        return request
    }
    
}



