//
//  StartViewController.swift
//  FliAlbum
//
//  Created by devdagad on 30/04/2019.
//  Copyright © 2019 devdagad. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var decreaseTimeButton: UIButton! 
    @IBOutlet weak var increateTimeButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    private var time: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func increseTime(_ sender: UIButton) {
        guard time < 10 else { return }
        time += 1
        setTime(time)
    }
    
    @IBAction func decreaseTime(_ sender: UIButton) {
        guard time > 0 else { return }
        time -= 1
        setTime(time)
    }
    
    private func setTime(_ time: Int) {
        self.timeLabel.text = String(time)
    }
    
    @IBAction func startSlideShow(_ sender: Any) {
        guard NetworkObserver.shared.isReachable else {
            UIAlertController.showNetworkAlert(.notReachable)
            return
        }
        let slideVC = SlideShowViewController(with: TimeInterval(time))
        navigationController?.pushViewController(slideVC, animated: true)
    }
}

