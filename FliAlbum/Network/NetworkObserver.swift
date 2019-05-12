//
//  InternetConnection.swift
//  FliAlbum
//
//  Created by Sangyeol Kang on 12/05/2019.
//  Copyright © 2019 devdagad. All rights reserved.
//

import Alamofire

class NetworkObserver {
    static let shared = NetworkObserver()
    
    private init() {}
    
    deinit {
        print("NetworkObserver deinit")
    }
    
    let reachabilityManager = NetworkReachabilityManager()
    
    var isReachable: Bool {
        return reachabilityManager?.isReachable ?? false
    }
    
    func startListening() {
        reachabilityManager?.listener = { status in
            switch status {
            case .notReachable:
                UIAlertController.showNetworkAlert(.notReachable)
                NotificationCenter.default.post(name: .networkDisconnected, object: nil)
            case .reachable(.ethernetOrWiFi):
                UIAlertController.showNetworkAlert(.reachable)
                NotificationCenter.default.post(name: .networkConnected, object: nil)
            case .reachable(.wwan):
                UIAlertController.showNetworkAlert(.reachable)
                NotificationCenter.default.post(name: .networkConnected, object: nil)
            default:
                return
            }
        }
        reachabilityManager?.startListening()
    }
    
    func stopListening() {
        reachabilityManager?.stopListening()
    }
}
