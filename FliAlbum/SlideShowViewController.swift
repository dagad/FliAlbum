//
//  SlideShowViewController.swift
//  FliAlbum
//
//  Created by devdagad on 01/05/2019.
//  Copyright © 2019 devdagad. All rights reserved.
//

import UIKit

class SlideShowViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    private var interval: TimeInterval
    private var fetcher = PhotoFetcher()
    private let waitQueue = DispatchQueue(label: "wait")
    
    private var photoIndex: Index = 0
    
    init(with interval: TimeInterval) {
        self.interval = interval
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("deinit SlideShowViewController")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetcher.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToForeGround),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(stopSlideShow),
                                               name: .networkDisconnected,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reStartSlideShow),
                                               name: .networkConnected,
                                               object: nil)
    }
    
    @objc func appMovedToForeGround() {
        waitQueue.resume()
    }
    
    @objc func appMovedToBackground() {
        waitQueue.suspend()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSlideShow()
    }
    
    private func startSlideShow() {
        fetcher.startFetch()
    }
    
    @objc private func reStartSlideShow() {
        print("reStartSlideShow")
        waitQueue.resume()
    }
    
    @objc private func stopSlideShow() {
        print("stopSlideShow")
        waitQueue.suspend()
        UIAlertController.showNetworkAlert(.notReachable)
    }
    
    private func changePhoto() {
        guard let photo = fetcher.photoAtIndexPath(photoIndex) else { return }
        imageView.alpha = 0
        imageView.image = photo.imageView.image
        photo.imageView.image = nil
        fadeIn()
        photoIndex += 1
    }
    
    private func fadeIn() {
        imageView.animate([.fadeIn(duration: 0.5)]) { [weak self] in
            self?.wait()
        }
    }
    
    private func wait() {
        waitQueue.asyncAfter(deadline: .now() + self.interval) { [weak self] in
            self?.fadeOut()
        }
    }
    
    private func fadeOut() {
        DispatchQueue.main.async { [weak self] in
            self?.imageView.animate([.fadeOut(duration: 0.5)]) {
                self?.changePhoto()
            }
        }
    }
}

extension SlideShowViewController: PhotoFetcherDelegate {
    func fetcher(_ fetcher: PhotoFetcher, didFetchItemList: [Photo]) {
        changePhoto()
    }
    
    func fetcher(_ fetcher: PhotoFetcher, didOccur error: Error) {
        
    }
}
