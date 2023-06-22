//
//  GetcoupnsModal.swift
//  wayUparty
//
//  Created by Arun on 06/04/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
// https://www.alchohome.com/ws/getCouponList

import Foundation
class GetcoupnsModal {
    let coupncode:Array<String>
    let coupnName:Array<String>
    let displayoffer:Array<String> 
    let discounttype:Array<String>
    let couponValue:Array<String>
    let minimumOrder:Array<String>
    
    
    init?(responceDict:[String:Any]) {
        guard let data = responceDict["data"] as? NSArray else {
            return nil
        }
        guard let coupnName = data.value(forKey: "couponName") as? Array<String>  else {
            return nil
        }
        guard let displayOffer = data.value(forKey: "displayOffer") as? Array<String> else {
            return nil
        }
        guard let coupncode = data.value(forKey: "couponCode") as? Array<String> else {
            return nil
        }
        guard let discountType = data.value(forKey: "discountType") as? Array<String> else {
            return nil
        }
        guard let couponvalue = data.value(forKey: "couponValue") as? Array<String> else {
            return nil
        }
        guard let minimumOrder = data.value(forKey: "minimumOrder") as? Array<String> else{return nil}
                 
      
        self.coupncode = coupncode
        self.coupnName = coupnName
        self.displayoffer = displayOffer
        self.discounttype = discountType
        self.couponValue = couponvalue
        self.minimumOrder = minimumOrder
        
}
}
