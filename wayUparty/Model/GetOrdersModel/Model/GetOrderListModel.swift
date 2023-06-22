//
//  GetOrderListModel.swift
//  Orders
//
//  Created by Jasty Saran  on 05/11/20.
//

import Foundation
struct GetOrderListModel{
    let data : NSArray
    let clubName: Array<String>
    let clubLocation: Array<String>
    let orderDate: Array<String>
    let orderItems: Array<String>
    let orderRates: Array<String>
    let totalAmount: Array<Double>
    let currency: Array<String>
    let qrCode: Array<String>
    let placeOrderCode:Array<String>
    let canceledOrdersCount : Array<Int>
    let orderStatus : Array<String>
    let orderUUIDs : Array<String>
    let orderItemsCanceled:Array<String>
    let orderItemsReschedule:Array<String>
    let isUserRated:Array<String>
    let rating:Array<Int>
    
    init?(responceDict:[String:Any]){
        guard let data = responceDict["data"] as? NSArray else{return nil}
        guard let clubName = data.value(forKey: "clubName") as? Array<String> else{return nil}
        guard let canceledOrdersCount = data.value(forKey: "canceledOrdersCount") as? Array<Int> else{return nil}
        guard let  isUserRated = data.value(forKey: "isUserRated") as? Array<String> else{return nil}
        guard let orderStatus = data.value(forKey: "orderStatus") as? Array<String> else{return nil}
        guard let clubLocation = data.value(forKey: "clubLocation") as? Array<String> else{return nil}
        guard let orderDate = data.value(forKey: "orderDate") as? Array<String> else{return nil}
        guard let orderItems = data.value(forKey: "orderItems") as? Array<String> else{return nil}
        guard let orderRates = data.value(forKey: "orderRates") as? Array<String> else{return nil}
        guard let totalAmount = data.value(forKey: "totalAmount") as? Array<Double> else{return nil}
        guard let currency = data.value(forKey: "currency") as? Array<String> else{return nil}
        guard let placeOrderCode = data.value(forKey: "placeOrderCode") as? Array<String>  else{return nil}
        guard let qrCode = data.value(forKey: "qrCode") as? Array<String> else{return nil}
        guard let rating = data.value(forKey: "rating") as? Array<Int> else{return nil}
        guard let orderUUIDs = data.value(forKey: "orderUUIDs") as? Array<String> else{return nil}
        guard let orderItemsCanceled = data.value(forKey: "orderItemsCanceled") as? Array<String> else{return nil}
        guard let orderItemsReschedule = data.value(forKey: "orderItemsReschedule") as? Array<String> else{return nil}
       
        self.data = data
        self.clubName = clubName
        self.clubLocation = clubLocation
        self.orderDate = orderDate
        self.orderItems = orderItems
        self.orderRates = orderRates
        self.totalAmount = totalAmount
        self.currency = currency
        self.qrCode = qrCode
        self.placeOrderCode = placeOrderCode
        self.rating = rating
        self.orderStatus = orderStatus
        self.canceledOrdersCount = canceledOrdersCount
        self.isUserRated = isUserRated
        self.orderUUIDs = orderUUIDs
        self.orderItemsCanceled = orderItemsCanceled
        self.orderItemsReschedule = orderItemsReschedule
    }
}
