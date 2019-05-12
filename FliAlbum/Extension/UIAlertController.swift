//
//  UIAlertController.swift
//  FliAlbum
//
//  Created by Sangyeol Kang on 12/05/2019.
//  Copyright © 2019 devdagad. All rights reserved.
//

import UIKit

enum NetworkStatus {
    case notReachable
    case reachable
    
    var title: String {
        switch self {
        case .notReachable:
            return "ERROR"
        case .reachable:
            return "Notification"
        }
        
    }
    
    var message: String {
        switch self {
        case .notReachable:
            return "The network is not reachable"
        case .reachable:
            return "The network is reachable"
        }
    }
}

extension UIAlertController {
    static func showNetworkAlert(_ status: NetworkStatus, handler: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            guard let handler = handler else { return }
            handler()
        }
        alertVC.addAction(action)
        guard let window = UIApplication.shared.keyWindow else { return }
        window.rootViewController?.present(alertVC, animated: true)
    }
}
