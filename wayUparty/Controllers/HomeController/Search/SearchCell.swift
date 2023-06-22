//
//  SearchCell.swift
//  wayUparty
//
//  Created by Arun  on 11/05/23.
//  Copyright © 2023 Arun. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        resImageView.layer.cornerRadius = 70
        resImageView.layer.borderWidth = 3
        resImageView.layer.borderColor = UIColor.white.cgColor
        servicesVw.layer.cornerRadius = 20
        servicesVw.clipsToBounds = true
        self.addressImage.setImageColor(color: UIColor.white)
        self.serviceImg.setImageColor(color: UIColor.white)
        self.specialImg.setImageColor(color: UIColor.white)
    }

}
