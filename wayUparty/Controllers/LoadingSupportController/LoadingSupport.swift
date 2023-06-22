//
//  LoadingSupport.swift
//  Jananetha
//
//  Created by jasty saran on 10/03/20.
//  Copyright © 2020 jasty saran. All rights reserved.
//

import UIKit

var isAnimationFalse = Bool()
class LoadingSupport: UIViewController {
    
    @IBOutlet weak var indicator: YRActivityIndicator!
    @IBOutlet weak var backgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkForRemovalofAnimation), userInfo: nil, repeats: true)
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.borderWidth = 0.1
        backgroundView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        indicator.startAnimating()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func hideViewWithAnimation() {
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.backgroundView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.alpha = 0
        }, completion: {(_ finished: Bool) -> Void in
            self.removeFromParent()
            self.view.removeFromSuperview()
        })
    }
    func showViewWithAnimation() {
        view.alpha = 0
        backgroundView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.backgroundView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 1
        })
    }

   @objc func checkForRemovalofAnimation(){
        if isAnimationFalse == true{hideViewWithAnimation()}
    }
}
