//
//  CountryListTableViewCell.swift
//  wayUparty
//
//  Created by pampana ajay on 21/06/23.
//  Copyright © 2023 Arun. All rights reserved.
//

import UIKit

class CountryListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBack:UIView!
    @IBOutlet weak var lblCountry:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBack.layer.cornerRadius = 12
    }

   
}
