//
//  GetServicesModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 30/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
struct GetServicesModel {
    let serviceId: NSArray
    let serviceName: NSArray
    let serviceUUID: NSArray
    let serviceImage: NSArray
    let isEntryRatioEnabled: NSArray
    let menRatio: NSArray
    let womenRatio: NSArray
    
    
    init?(responceDict:[String:Any]){
        guard let object = responceDict["object"] as? [String:Any]  else{return nil}
        guard let serviceList = object["servicesList"] as? NSArray else{return nil}
        guard let serviceId = serviceList.value(forKey: "serviceId") as? NSArray else{return nil}
        guard let serviceName = serviceList.value(forKey: "serviceName") as? NSArray else{return nil}
        guard let isEntryRatioEnabled = serviceList.value(forKey: "isEntryRatioEnabled") as? NSArray else{return nil}
        guard let menRatio = serviceList.value(forKey: "menRatio") as? NSArray else{return nil}
        guard let womenRatio = serviceList.value(forKey: "womenRatio") as? NSArray else{return nil}
        guard let serviceUUID = serviceList.value(forKey: "serviceUUID") as? NSArray else{return nil}
        guard let serviceImage = serviceList.value(forKey: "serviceImage") as? NSArray else{return nil}
       // guard let mlDetailsListInfo = serviceList.value(forKey: "mlDetailsListInfo") as? NSArray else{return nil}
        self.serviceId = serviceId
        self.serviceName = serviceName
        self.serviceUUID = serviceUUID
        self.serviceImage = serviceImage
        self.isEntryRatioEnabled = isEntryRatioEnabled
        self.menRatio = menRatio
        self.womenRatio = womenRatio
        //self.mlDetailsListInfo = mlDetailsListInfo
    }
}
