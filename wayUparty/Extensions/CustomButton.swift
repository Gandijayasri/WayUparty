//
//  CustomButton.swift
//  wayUparty
//
//  Created by Arun on 21/02/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//



import UIKit

final class CustomButton: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
}


extension UIView{
    func createShadow(_ color:UIColor, radius: CGFloat, shadowOffset:CGSize, shadowOpacity:Float) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
       
    }
    
}
