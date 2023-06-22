//
//  SelectEntryCell.swift
//  wayUparty
//
//  Created by Arun on 22/02/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit

class SelectEntryCell: UITableViewCell {
    
    @IBOutlet var titleBtn: CustomButton!
    @IBOutlet var shadowVw: UIView!
    
    @IBOutlet var amountLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleBtn.isUserInteractionEnabled = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
