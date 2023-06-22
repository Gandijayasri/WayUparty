//
//  EventsTableViewCell.swift
//  wayUparty
//
//  Created by Arun on 12/04/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    @IBOutlet var eventsImg: UIImageView!
    
    @IBOutlet var bgView: UIView!
    
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var locationLbl: UILabel!
    
    @IBOutlet var itemsLbl: UILabel!
    
    @IBOutlet var exploreBtn: UIButton!
    
    @IBOutlet var ratingLbl: UILabel!
    
    @IBOutlet var eventsBtn: UIButton!
    
    @IBOutlet var specialImg: UIImageView!
    
    @IBOutlet var exploreImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.specialImg.setImageColor(color: UIColor.black)
        self.exploreImg.setImageColor(color: UIColor.black)
        bgView.layer.borderWidth = 0.8
       // bgView.layer.borderColor = UIColor.white.cgColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
