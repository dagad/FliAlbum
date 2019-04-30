//
//  PhotoAPI.swift
//  FliAlbum
//
//  Created by dagad on 30/04/2019.
//  Copyright © 2019 devdagad. All rights reserved.
//

import Moya

enum PhotoAPI {
    case feedList
}

extension PhotoAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.flickr.com")!
    }

    var path: String {
        switch self {
        case .feedList:
            return "/services/feeds/photos_public.gne"
        }
    }

    var method: Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        return nil
    }
}
