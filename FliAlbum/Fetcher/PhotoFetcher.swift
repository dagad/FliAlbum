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
    func fetcher(_ fetcherReadyToShow: PhotoFetcher)
    func fetcher(_ fetcher: PhotoFetcher, didOccur error: Error)
}

// swiftlint:disable identifier_name
enum FetchState {
    case fetching
    case fetched(photo: Photo)
    case failed
}
// swiftlint:enable identifier_name

enum DownloadTarget {
    case states
    case buffer
    case preLoadedStates
}

class PhotoFetcher: NSObject {
    
    weak var delegate: PhotoFetcherDelegate?
    
    private var states: [Index: FetchState] = [:]
    private var buffer: [Index: FetchState] = [:]
    private var preLoadedStates: [Index: FetchState] = [:]
    
    private var isFirst = true
    
    deinit {
        print("fetcher deinit")
    }
    
    func clear() {
        states.removeAll(keepingCapacity: true)
    }
    
    func startFetch() {
        let group = DispatchGroup()
        group.enter()
        requestPhotos(to: .states, group: group)
        group.enter()
        requestPhotos(to: .buffer, group: group)
        requestPhotos(to: .preLoadedStates)
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else { return }
            self?.delegate?.fetcher(strongSelf)
        }
    }
    
    private func preFetch() {
        requestPhotos(to: .preLoadedStates)
    }
    
    func photoAtIndexPath(_ index: Index) -> Photo? {
        guard let fetchState = states[index] else { return nil }
        if case let .fetched(photo) = fetchState {
            states[index] = buffer[index]
            buffer[index] = nil
            
            if buffer.isEmpty {
                buffer = preLoadedStates
                preLoadedStates.removeAll()
                preFetch()
            }
            
            return photo
        } else {
            return nil
        }
    }
}

// MARK: - Server API
extension PhotoFetcher {
    private func requestPhotos(to target: DownloadTarget, group: DispatchGroup? = nil) {
        PhotoService.shared.getPhotos(success: { [weak self] photos in
            guard let photos = photos else { return }
            self?.downloadImages(from: photos, to: target, group: group)
        }, failure: { error in
            
        })
    }
    
    private func downloadImages(from photos: [Photo], to target: DownloadTarget, group: DispatchGroup? = nil) {
        let downloadImageGroup = DispatchGroup()
        for (index, photo) in photos.enumerated() {
            downloadImageGroup.enter()
            photo.downloadImage { [weak self] in
                switch target {
                case .states:
                    print("downloaded Image at states index:\(index)")
                    self?.states[index] = .fetched(photo: photo)
                case .buffer:
                    print("downloaded Image at buffer index:\(index)")
                    self?.buffer[index] = .fetched(photo: photo)
                case .preLoadedStates:
                    print("downloaded Image at preLoadedState index:\(index)")
                    self?.preLoadedStates[index] = .fetched(photo: photo)
                }
                downloadImageGroup.leave()
            }
        }
        
        downloadImageGroup.notify(queue: DispatchQueue.main) {
            group?.leave()
        }
    }
}
