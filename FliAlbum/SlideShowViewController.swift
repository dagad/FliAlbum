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
    private var myTimer: Timer?
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
        let timer = Timer(timeInterval: interval, repeats: true) { [weak self] timer in
            self?.changePhoto()
        }
        myTimer = timer
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSlideShow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        myTimer?.invalidate()
    }
    
    private func changePhoto() {
        guard let photo = fetcher.photoAtIndexPath(photoIndex) else { return }
        print(photoIndex)
        
        photoIndex += 1
    }
    
    private func startSlideShow() {
        fetcher.startFetch()
    }
}

extension SlideShowViewController: PhotoFetcherDelegate {
    func fetcher(_ fetcher: PhotoFetcher, didFetchItemList: [Photo]) {
        guard let timer = myTimer else { return }
        RunLoop.current.add(timer, forMode: .default)
    }
    
    func fetcher(_ fetcher: PhotoFetcher, didOccur error: Error) {
        
    }
}
