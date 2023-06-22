//
//  HomeCollection.swift
//  wayUparty
//
//  Created by Arun on 17/02/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import UIKit

class HomeCollection: UICollectionViewCell {

    @IBOutlet weak var resImageView: UIImageView!
    @IBOutlet weak var restaurentTitle: UILabel!
    
    @IBOutlet weak var restuarentLocation: UILabel!
    
    @IBOutlet var addressImage: UIImageView!
    
    @IBOutlet var serviceImg: UIImageView!
    
    @IBOutlet weak var ratingView: UIView!
    
    @IBOutlet weak var servicesIconBtn: UIButton!
    
    @IBOutlet var servicesVw: UIView!
    @IBOutlet weak var servicesTextBtn: UIButton!
    
    @IBOutlet var specialImg: UIImageView!
    
    @IBOutlet var servicelbl: UILabel!
    
    static let isEnabledAllowsUserInteractionWhileHighlightingCard = true
    var disabledHighlightedAnimation = false
    override func awakeFromNib() {
        super.awakeFromNib()
        resImageView.layer.cornerRadius = 70
        resImageView.layer.borderWidth = 3
        resImageView.layer.borderColor = UIColor.white.cgColor
        servicesVw.layer.cornerRadius = 22
        servicesVw.clipsToBounds = true
        self.addressImage.setImageColor(color: UIColor.white)
        self.serviceImg.setImageColor(color: UIColor.white)
        self.specialImg.setImageColor(color: UIColor.white)
        
    }

}
