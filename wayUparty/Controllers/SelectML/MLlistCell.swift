//
//  MLlistCell.swift
//  wayUparty
//
//  Created by Arun on 07/03/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit

class MLlistCell: UITableViewCell {

    @IBOutlet var actualPriceLbl: UILabel!
    
    @IBOutlet var offerPriceLbl: UILabel!
    
    @IBOutlet var quantityLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
