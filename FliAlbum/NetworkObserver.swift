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
    
    func startListening() {
        reachabilityManager?.listener = { status in
            switch status {
            case .notReachable:
                UIAlertController.showNetworkAlert(.notReachable)
            case .reachable(.ethernetOrWiFi):
                UIAlertController.showNetworkAlert(.reachable)
            case .reachable(.wwan):
                UIAlertController.showNetworkAlert(.reachable)
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
