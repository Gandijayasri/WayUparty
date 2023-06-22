//
//  UIViewExtension.swift
//  wayUparty
//
//  Created by Jasty Saran  on 25/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
extension UIView {
   func createDottedLine(width: CGFloat, color: CGColor) {
      let caShapeLayer = CAShapeLayer()
      caShapeLayer.strokeColor = color
      caShapeLayer.lineWidth = width
      caShapeLayer.lineDashPattern = [1,4]
      let cgPath = CGMutablePath()
      let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
      cgPath.addLines(between: cgPoint)
      caShapeLayer.path = cgPath
      layer.addSublayer(caShapeLayer)
   }
}
extension UIViewController{
    func showToastatbottom(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: 350, width: 300, height: 50))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
       
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 11.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    @objc dynamic func _tracked_viewWillAppear(_ animated: Bool) {
        
        print("Screen_Name: "+String(describing: type(of: self)))
        _tracked_viewWillAppear(animated)
    }
    
    static func swizzle() {
        if self != UIViewController.self {
            return
        }
        let _: () = {
            let originalSelector =
            #selector(UIViewController.viewWillAppear(_:))
            let swizzledSelector =
            #selector(UIViewController._tracked_viewWillAppear(_:))
            let originalMethod =
            class_getInstanceMethod(self, originalSelector)
            let swizzledMethod =
            class_getInstanceMethod(self, swizzledSelector)
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }()
    }
    func delay(seconds: Double, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }

    func showSwiftLoader()  {
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 130
        config.backgroundColor = UIColor.clear
        config.spinnerColor = UIColor.white
        config.spinnerLineWidth = 3.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.2
        
        SwiftLoader.setConfig(config)
        
        SwiftLoader.show(animated: true)
    }
    func hideSwiftLoader()  {
        delay(seconds: 0.01) { () -> () in
            SwiftLoader.hide()
        }
    }
}


