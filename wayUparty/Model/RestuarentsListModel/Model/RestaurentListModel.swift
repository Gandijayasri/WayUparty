//
//  RestaurentListModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 19/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
struct RestuarentListModel{
    let data : NSArray
    var vendorName : Array<String>
    var vendorEmail : Array<String>
    var vendorMobile : Array<String>
    var vendorUUID : Array<String>
    var vendorProfileImg : Array<String>
    var vendorCode : Array<String>
    var bestSellingItems : Array<String>
    var location : Array<String>
    var costForTwoPeople: Array<Int>
    var kilometers:Array<Double>
    
    
    init?(responceDict:[String:Any]){
         guard let data = responceDict["data"] as? NSArray else {return nil}
        print("count:\(data.count)")
         guard let vendorName = data.value(forKey:"vendorName") as? Array<String> else{return nil}
         guard let vendorEmail = data.value(forKey:"vendorEmail") as? Array<String> else{return nil}
         guard let vendorMobile = data.value(forKey:"vendorMobile") as? Array<String> else{return nil}
         guard let vendorUUID = data.value(forKey:"vendorUUID") as? Array<String> else{return nil}
         guard let vendorProfileImg = data.value(forKey:"vendorProfileImg") as? Array<String> else{return nil}
         guard let vendorCode = data.value(forKey:"vendorCode") as? Array<String> else{return nil}
         guard let bestSellingItems = data.value(forKey:"bestSellingItems") as? Array<String> else{return nil}
         guard let location = data.value(forKey:"location") as? Array<String> else{return nil}
        guard let kilometers = data.value(forKey: "kilometers") as? Array<Double> else {
            return nil
         }
         guard let costForTwoPeople = data.value(forKey: "costForTwoPeople") as? Array<Int> else{return nil}
        
        self.data = data
        self.vendorName = vendorName
        self.vendorEmail = vendorEmail
        self.vendorMobile = vendorMobile
        self.vendorCode = vendorCode
        self.location = location
        self.bestSellingItems = bestSellingItems
        self.vendorProfileImg = vendorProfileImg
        self.vendorUUID = vendorUUID
        self.costForTwoPeople = costForTwoPeople
        self.kilometers = kilometers
    }
}

struct FiltersListModel {
    let data : NSArray
    var categoryId:Array<Int>
    var categoryName: Array<String>
    var categoryUUID: Array<String>
    init?(responceDict:[String:Any]){
        guard let data = responceDict["data"] as? NSArray else {return nil}
        guard let categid = data.value(forKey: "categoryId") as? Array<Int> else{return nil}
        guard let categoryName = data.value(forKey:"categoryName") as? Array<String> else{return nil}
        guard let categoryUUID = data.value(forKey:"categoryUUID") as? Array<String> else{return nil}
        
        self.data = data
        self.categoryId = categid
        self.categoryName = categoryName
        self.categoryUUID = categoryUUID
    }

    
}
