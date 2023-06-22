//
//  OfferListDataModel.swift
//  wayUparty
//
//  Created by Arun on 11/04/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import Foundation
class OfferListDataModel : NSObject{
    
    var title : String!
    var identity : Int!
    
    init(_ title:String, _ identity:Int) {
        super.init()
        self.title = title
        self.identity = identity
    }
    
}
