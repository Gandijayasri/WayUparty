//
//  UITextFeildExtension.swift
//  Jananetha
//
//  Created by jasty saran on 07/02/20.
//  Copyright © 2020 jasty saran. All rights reserved.
//

import UIKit
extension UITextField{
    func setTextFeildBorderLine(txtFeild:UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x:0.0, y:txtFeild.frame.height - 1, width:txtFeild.frame.width, height:1.0)
        bottomLine.backgroundColor = UIColor.black.cgColor
        txtFeild.borderStyle = UITextField.BorderStyle.none
        txtFeild.layer.addSublayer(bottomLine)
    }
    
    func shakeTheTextFeild(txtFeild:UITextField,text:String){
        let animation = CABasicAnimation(keyPath: "position")
        txtFeild.text = text
        txtFeild.textColor = UIColor.red
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: txtFeild.center.x - 10, y: txtFeild.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: txtFeild.center.x + 10, y: txtFeild.center.y))
        txtFeild.layer.add(animation, forKey: "position")
    }
    
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }

    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder()
        
    }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}
