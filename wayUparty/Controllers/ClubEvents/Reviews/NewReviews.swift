//
//  NewReviews.swift
//  wayUparty
//
//  Created by Arun  on 10/05/23.
//  Copyright © 2023 Arun. All rights reserved.
//

import UIKit
import AARatingBar

class NewReviews: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var descripLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
