//
//  PhotoFetcher.swift
//  FliAlbum
//
//  Created by devdagad on 01/05/2019.
//  Copyright © 2019 devdagad. All rights reserved.
//

import Moya

protocol PhotoFetcherDelegate: class {
    func fetcher(_ fetcher: PhotoFetcher, didFetchItemsAt indexPaths: [IndexPath])
    func fetcher(_ fetcher: PhotoFetcher, didUpdateTotalCount totalCount: Int)
    func fetcher(_ fetcher: PhotoFetcher, didOccur error: Error)
}

enum FetchState {
    case fetching
    case fetched(photo: Photo)
    case failed
}

class PhotoFetcher: NSObject {
    
    weak var delegate: PhotoFetcherDelegate?
    
    private var states: [IndexPath: FetchState] = [:]
    
    deinit {
        print("fetcher deinit")
    }
    
    func clear() {
        
    }
    
    func photoAtIndexPath(_ indexPath: IndexPath) -> Photo? {
        
    }
}

// MARK: - Server API
extension PhotoFetcher {
    
}
