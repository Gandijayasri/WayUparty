//
//  GenerateOrderIDModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 13/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
struct GenerateOrderIDModel {
    let amount:Int
    let orderId:String
    let receipt:String
    let currency:String
    
    init?(responceDict:[String:Any]){
        guard let object = responceDict["object"] as? [String:Any] else {
            return nil
        }
        guard let amount = object["amount"] as? Int else {
            return nil
        }
        guard let orderId = object["orderId"] as? String else {
            return nil
        }
        guard let receipt = object["receipt"] as? String else {
            return nil
        }
        guard let currency = object["currency"] as? String else {
            return nil
        }
        
        self.amount = amount
        self.orderId = orderId
        self.currency = currency
        self.receipt = receipt
    }
}
