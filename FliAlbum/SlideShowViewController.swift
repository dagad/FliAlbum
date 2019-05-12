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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSlideShow()
    }
    
    private func startSlideShow() {
        fetcher.startFetch()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + self.interval) { [weak self] in
            self?.fadeOut()
        }
    }
    
    private func fadeOut() {
        imageView.animate([.fadeOut(duration: 0.5)]) { [weak self] in
            self?.changePhoto()
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
