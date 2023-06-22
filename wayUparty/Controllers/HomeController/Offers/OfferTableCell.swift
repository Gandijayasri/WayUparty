//
//  OfferTableCell.swift
//  wayUparty
//
//  Created by Arun on 11/04/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit

class OfferTableCell: UITableViewCell {
    
    @IBOutlet weak var lblItem: UILabel!
    
    @IBOutlet weak var imgLeadingCheck: UIImageView!
    @IBOutlet weak var widthOfImgLeadingCheck: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
