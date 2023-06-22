//
//  InfoCell.swift
//  wayUparty
//
//  Created by Arun  on 03/05/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    
    @IBOutlet weak var costlbl: UILabel!
    
    @IBOutlet weak var capacityLbl: UILabel!
    
    @IBOutlet weak var yearLbl: UILabel!
    
    @IBOutlet weak var itemsLbl: UILabel!
    
    @IBOutlet weak var emailLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
