//
//  ImagesListPresenterSpy.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 18.10.2024.
//

import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
      var fetchNextPhotosCalled: Bool = false

      func fetchNextPhotos() {
          fetchNextPhotosCalled = true
      }

      func changeImageLikeState(row: Int) {

      }

      func getCountOfImages() -> Int {
          return 10
      }

      func getLargeImageURL(row: Int) -> String {
          return ""
      }

      func getSizeOfImage(row: Int) -> CGSize {
          return .zero
      }

      func getImageId(row: Int) -> String {
          return ""
      }

      func isImageLiked(row: Int) -> Bool {
          return false
      }

      func getThumbnailImageURL(row: Int) -> String {
          return ""
      }

      func getImageCreated_at(row: Int) -> Date? {
          return nil
      }
  }

