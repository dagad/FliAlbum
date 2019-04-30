//
//  PhotoService.swift
//  FliAlbum
//
//  Created by dagad on 30/04/2019.
//  Copyright © 2019 devdagad. All rights reserved.
//

import Moya
import Moya_ModelMapper

class PhotoService {
    static let shared = PhotoService()
    private let provider = MoyaProvider<PhotoAPI>()

    private init() {}

    func getPhotos(success: @escaping ([Photo]?) -> Void, failure: @escaping (Error) -> Void) {
        provider.request(.feedList) { result in
            switch result {
            case let .success(response):
                if let photos = try? response.map(to: [Photo].self, keyPath: "items") {
                    success(photos)
                } else {
                    success(nil)
                }
            case let .failure(error):
                print(error)
                failure(error)
            }
        }

    }
}
