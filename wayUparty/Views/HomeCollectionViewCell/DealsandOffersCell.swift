//
//  DealsandOffersCell.swift
//  wayUparty
//
//  Created by Arun  on 10/05/23.
//  Copyright © 2023 Arun. All rights reserved.
//

import UIKit

class DealsandOffersCell: UICollectionViewCell {
    @IBOutlet weak var discountLbl: UILabel!
    
    @IBOutlet weak var contView: UIView!
    
    var backColor = UIColor()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backColor = UIColor(red: 243/255, green: 194/255, blue: 69/255, alpha: 1)
        contView.layer.borderWidth = 2
        contView.layer.borderColor = UIColor.white.cgColor
        contView.layer.masksToBounds = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        contView.backgroundColor = UIColor.clear
        discountLbl.textColor = UIColor.white
    }

}
