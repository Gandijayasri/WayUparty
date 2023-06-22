//
//  EventList.swift
//  wayUparty
//
//  Created by Arun  on 03/05/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit

class EventList: UICollectionViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.setRoundEdge(radius: 10, bordercolor: UIColor.white)
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 20
    }

}
