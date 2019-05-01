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
    private weak var myTimer: Timer?
    
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
        let timer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
            self?.changePhoto()
        }
        myTimer = timer
        RunLoop.current.add(timer, forMode: .default)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        myTimer?.invalidate()
    }
    
    private func changePhoto() {

    }
}
