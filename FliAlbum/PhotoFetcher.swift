//
//  PhotoFetcher.swift
//  FliAlbum
//
//  Created by devdagad on 01/05/2019.
//  Copyright © 2019 devdagad. All rights reserved.
//

import Moya

typealias Index = Int

protocol PhotoFetcherDelegate: class {
    func fetcher(_ fetcher: PhotoFetcher, didFetchItemList: [Photo])
    func fetcher(_ fetcher: PhotoFetcher, didOccur error: Error)
}

enum FetchState {
    case fetching
    case fetched(photo: Photo)
    case failed
}

class PhotoFetcher: NSObject {
    
    weak var delegate: PhotoFetcherDelegate?
    
    private var states: [Index: FetchState] = [:]
    
    deinit {
        print("fetcher deinit")
    }
    
    func clear() {
        states.removeAll(keepingCapacity: true)
    }
    
    func startFetch() {
        requestPhotos()
    }
    
    func photoAtIndexPath(_ index: Index) -> Photo? {
        guard let fetchState = states[index] else { return nil }
        if case let .fetched(photo) = fetchState {
            return photo
        } else {
            return nil
        }
    }
}

// MARK: - Server API
extension PhotoFetcher {
    private func requestPhotos() {
        PhotoService.shared.getPhotos(success: { [weak self] photos in
            guard let photos = photos else { return }
            guard let strongSelf = self else { return }
            for (index, photo) in photos.enumerated() {
                self?.states[index] = .fetched(photo: photo)
            }
            self?.delegate?.fetcher(strongSelf, didFetchItemList: photos)
        }, failure: { error in
            
        })
    }
}
