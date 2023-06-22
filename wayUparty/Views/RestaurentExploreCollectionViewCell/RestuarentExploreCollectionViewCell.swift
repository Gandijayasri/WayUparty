//
//  RestuarentExploreCollectionViewCell.swift
//  wayUparty
//
//  Created by Jasty Saran  on 02/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
class RestuarentExploreCollectionViewCell:UICollectionViewCell{
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var shawdowView: UIView!
    override func awakeFromNib() {
        shawdowView.layer.cornerRadius = 16
        shawdowView.layer.masksToBounds = true
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12
        //cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
}
