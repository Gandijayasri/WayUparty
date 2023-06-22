//
//  GetCartListModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 16/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
struct GetCartListModel{
    let data: NSArray
    let serviceName:Array<String>
    let orderAmount:Array<Double>
    let quantity:Array<Int>
    let totalAmount:Array<Double>
    let cartUUID:Array<String>
    let serviceOrderDate:Array<String>
    let timeSlot:Array<String>
    let serviceImage:Array<String>
    let currency:Array<String>
    let razorpayKeyId : String
    let razorpayKeySecretId : String
    
    init?(responceDict:[String:Any]){
        guard let data = responceDict["data"] as? NSArray else{return nil}
        guard let razorpayKeyId = responceDict["razorpayKeyId"] as? String else{return nil}
        guard let razorpayKeySecretId = responceDict["razorpayKeySecretId"] as? String else{return nil}
        guard let serviceName = data.value(forKey: "serviceName") as? Array<String> else{ return nil}
        guard let orderAmount = data.value(forKey: "orderAmount") as? Array<Double> else{ return nil}
        guard let quantity = data.value(forKey: "quantity") as? Array<Int> else{ return nil}
        guard let totalAmount = data.value(forKey: "totalAmount") as? Array<Double> else{ return nil}
        guard let cartUUID = data.value(forKey: "cartUUID") as? Array<String> else{ return nil}
        guard let serviceOrderDate = data.value(forKey: "serviceOrderDate") as? Array<String> else{ return nil}
        guard let timeSlot = data.value(forKey: "timeSlot") as? Array<String> else{ return nil}
        guard let serviceImage = data.value(forKey: "serviceImage") as? Array<String> else{ return nil}
        guard let currency = data.value(forKey: "currency") as? Array<String> else{ return nil}
        
        self.data = data
        self.razorpayKeyId = razorpayKeyId
        self.razorpayKeySecretId = razorpayKeySecretId
        self.serviceName = serviceName
        self.orderAmount = orderAmount
        self.quantity = quantity
        self.totalAmount = totalAmount
        self.cartUUID = cartUUID
        self.serviceOrderDate = serviceOrderDate
        self.timeSlot = timeSlot
        self.serviceImage = serviceImage
        self.currency = currency
    }
}
