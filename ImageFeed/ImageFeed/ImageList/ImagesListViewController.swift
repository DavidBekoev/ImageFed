//
//  ViewController.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 04.07.2024.
//

import UIKit
import Kingfisher
class ImagesListViewController: UIViewController {
    
    
    
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    @IBOutlet private var tableView: UITableView!
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    //    private lazy var dateFormatter: DateFormatter = {
    //        let formatter = DateFormatter()
    //        formatter.dateStyle = .long
    //        formatter.timeStyle = .none
    //        return formatter
    //    }() 
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        tableView.rowHeight = 200
        tableView.backgroundColor = .black
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
        fetchNextPhotos()
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            let urlString = photos[indexPath.row].largeImageURL
            viewController.fullImageURLString = urlString
        } else {
            super.prepare(for: segue, sender: sender)
        }
        
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func fetchNextPhotos() {
        imagesListService.fetchPhotosNextPage() { result in
            switch result {
            case .success(let body):
                debugPrint("[ImagesListViewController fetchNextPhotos] Next pack of images loaded")
            case .failure(let error):
                debugPrint("[ImagesListViewController fetchNextPhotos] Next pack of images loading failed\n \(error)")
            }
        }
    }
    
    
    
}


extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell,
              let url: URL = URL(string: photos[indexPath.row].thumbImageURL)
        else {
            return UITableViewCell()
        }
        
        //configCell(for: imageListCell, with: indexPath)
        // configCell(for: imageListCell, with: indexPath, url: url)
        //imageListCell.configCell(with: indexPath)
        //   imageListCell.configCell(tableView, with: indexPath, url: url)
        
        imageListCell.delegate = self
        let isLiked = self.photos[indexPath.row].isLiked
        imageListCell.configCell(tableView, with: indexPath, url: url, isLiked: isLiked)
        return imageListCell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success(let body):
                debugPrint("[ImagesListViewController imageListCellDidTapLike] Like/unlike request done")
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == body.photo.id }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            created_at: photo.created_at,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: !photo.isLiked
                        )
                        self.photos[index] = newPhoto
                        cell.setIsLiked(isLike: !photo.isLiked)
                        UIBlockingProgressHUD.dismiss()
                    }
                }
            case .failure(let error):
                debugPrint("[ImagesListViewController imageListCellDidTapLike] Like/unlike request failed\n \(error)")
                UIBlockingProgressHUD.dismiss()
            }
        }
        
    }
    
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            fetchNextPhotos()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size: CGSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}


