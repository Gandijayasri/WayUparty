//
//  ViewControllerExtension.swift
//  wayUparty
//
//  Created by Arun on 12/04/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
    func hideKeyboardWhenTappedAround() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: self.view.frame.size.height-150, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.lightGray
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
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
}
extension UILabel {

   
    func setRoundEdge(radius:CGFloat,bordercolor:UIColor) {
    self.layer.borderWidth = 1.0
    self.layer.cornerRadius = radius
    self.layer.borderColor = bordercolor.cgColor
    self.layer.masksToBounds = true
    self.clipsToBounds = true
    }
}

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}
