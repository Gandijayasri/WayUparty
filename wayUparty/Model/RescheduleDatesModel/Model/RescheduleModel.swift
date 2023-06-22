//
//  RescheduleModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 17/12/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
struct RescheduleModel {
    let object:[String:Any]
    let timeSlotList:NSArray
    let serviceDates:NSArray
    
    init?(responceDict:[String:Any]){
        guard let object = responceDict["object"] as? [String:Any] else{return nil}
        guard let timeSlotList = object["timeSlotList"] as? NSArray else{return nil}
        guard let serviceDates = object["serviceDates"] as? NSArray else{return nil}
        
        self.object = object
        self.timeSlotList = timeSlotList
        self.serviceDates = serviceDates
    }
}
