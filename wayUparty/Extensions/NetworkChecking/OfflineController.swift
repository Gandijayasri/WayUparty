//
//  OfflineController.swift
//  wayUparty
//
//  Created by Arun on 02/03/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import UIKit

class OfflineController: UIViewController {
    @IBOutlet weak var gifView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadgifImage()
        NotificationCenter.default.addObserver(self, selector: #selector(OfflineController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
    }
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
            let state = Reach().connectionStatus()
            switch state {
            case .unknown, .offline:
                print("Not connected")
            case .online(.wwan):
                self.dismiss(animated: true, completion: nil)
            case .online(.wiFi):
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    

    func loadgifImage() {
        let jeremyGif = UIImage.gifImageWithName("network")
        let imageView = UIImageView(image: jeremyGif)
        imageView.frame = CGRect(x: 0, y: 0, width: self.gifView.frame.size.width, height:self.gifView.frame.height)
         imageView.animationImages = jeremyGif?.images
         imageView.animationRepeatCount = 5
         self.gifView.addSubview(imageView)
         
    }

}
