//
//  GetServicesListModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 01/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class GetServicesListModel{
    let subCategory:Array<String>
    let actualPrice:Array<Double>
    let offerPrice:Array<Double>
    let currency:Array<String>
    let serviceUUID:Array<String>
    let serviceId:Array<Int>
    let vendorId:Array<Int>
    let serviceImage:Array<String>
    let timeSlotList:NSArray
    let serviceDates:NSArray
    let allowed:Array<Int>
    let termsAndConditions:Array<String>
    let startTime:NSArray
    let endTime:NSArray
    let passableDate:NSArray
    let serviceDate:NSArray
    let startDate:Array<String>
    let endDate:Array<String>
    let packageMenuItems:NSArray
    let discountValue:Array<Double>
    let discountType:Array<String>
    let surpriseForList:NSArray
    let surpriseUUID:Array<Any>
    let surpriseName:Array<Any>
    let surpriseOccationList:NSArray
    let occationSupriseName:Array<Any>
    let occationSupriseUUID:Array<Any>
    let mlDetailsListInfo:NSArray
    let typeName:Array<Any>
    let typeActualPrice:Array<Any>
    let typeOfferPrice:Array<Any>
    
    
    
    
    
    
    
    init?(responceDict:[String:Any]){
        guard let data = responceDict["data"] as? NSArray else{return nil}
        guard let subCategory = data.value(forKey: "subCategory") as? Array<String> else{return nil}
        guard let actualPrice = data.value(forKey: "actualPrice") as? Array<Double> else{return nil}
        guard let offerPrice = data.value(forKey: "offerPrice") as? Array<Double> else{return nil}
        guard let currency = data.value(forKey: "currency") as? Array<String> else{return nil}
        guard let serviceUUID = data.value(forKey: "masterServiceUUID") as? Array<String> else{return nil}
         guard let serviceImage = data.value(forKey: "serviceImage") as? Array<String> else{return nil}
        guard let timeSlotList = data.value(forKey: "timeSlotList") as? NSArray else{return nil}
        guard let serviceDates = data.value(forKey: "serviceDates") as? NSArray else{return nil}
         guard let allowed = data.value(forKey: "allowed") as? Array<Int> else{return nil}
        guard let termsAndConditions = data.value(forKey: "termsAndConditions") as? Array<String> else{return nil}
        guard let startTime = timeSlotList.value(forKey: "startTime") as? NSArray else{return nil}
        guard let endTime = timeSlotList.value(forKey: "endTime") as? NSArray else{return nil}
        guard let passableDate = serviceDates.value(forKey: "passableDate") as? NSArray else{return nil}
        guard let serviceDate = serviceDates.value(forKey: "serviceDate") as? NSArray else{return nil}
        guard let startDate = data.value(forKey: "startDate") as? Array<String> else{return nil}
        guard let endDate = data.value(forKey: "endDate") as? Array<String> else{return nil}
        guard let serviceId = data.value(forKey: "serviceId") as? Array<Int> else{return nil}
        guard let vendorId = data.value(forKey: "vendorId") as? Array<Int> else {return nil}
        guard let packageMenuItems = data.value(forKey: "packageMenuItems") as? NSArray else{return nil}
        guard let discountValue = data.value(forKey: "discountValue") as? Array<Double> else{return nil}
        guard let discountType = data.value(forKey: "discountType") as? Array<String> else{return nil}
        guard let surpriseForList = data.value(forKey: "surpriseForList") as? NSArray else{return nil}
        guard let surpriseUUID = surpriseForList.value(forKey: "surpriseUUID") as? Array<Any> else{return nil}
        guard let surpriseName = surpriseForList.value(forKey: "surpriseName") as? Array<Any> else{return nil}
        guard let surpriseOccationList = data.value(forKey: "surpriseOccationList") as? NSArray else{return nil}
        guard let occationSupriseName = surpriseOccationList.value(forKey: "surpriseName") as? Array<Any> else{return nil}
        guard let occationSupriseUUID = surpriseOccationList.value(forKey: "surpriseUUID") as? Array<Any> else{return nil}
        guard let mlDetailsListInfo = data.value(forKey: "mlDetailsListInfo") as? NSArray else{return nil}
        guard let typeName = mlDetailsListInfo.value(forKey: "typeName") as? Array<Any> else {return nil}
        guard let typeActualPrice = mlDetailsListInfo.value(forKey: "typeActualPrice") as? Array<Any> else {return nil}
        guard let typeOfferPrice = mlDetailsListInfo.value(forKey: "typeOfferPrice") as? Array<Any> else {return nil}
        self.subCategory = subCategory
        self.actualPrice = actualPrice
        self.offerPrice = offerPrice
        self.currency = currency
        self.serviceUUID = serviceUUID
        self.serviceImage = serviceImage
        self.timeSlotList = timeSlotList
        self.serviceDates = serviceDates
        self.allowed = allowed
        self.termsAndConditions = termsAndConditions
        self.startTime = startTime
        self.endTime = endTime
        self.passableDate = passableDate
        self.serviceDate = serviceDate
        self.startDate = startDate
        self.endDate = endDate
        self.vendorId = vendorId
        self.serviceId = serviceId
        self.packageMenuItems = packageMenuItems
        self.discountValue = discountValue
        self.discountType = discountType
        self.surpriseForList = surpriseForList
        self.surpriseUUID = surpriseUUID
        self.surpriseName = surpriseName
        self.surpriseOccationList = surpriseOccationList
        self.occationSupriseName = occationSupriseName
        self.occationSupriseUUID = occationSupriseUUID
        self.mlDetailsListInfo = mlDetailsListInfo
        self.typeName = typeName
        self.typeActualPrice = typeActualPrice
        self.typeOfferPrice = typeOfferPrice
        
    }
}
