//
//  EventTimeSlotsModel.swift
//  EventsModule
//
//  Created by Jasty Saran  on 25/12/20.
//

import Foundation
struct EventTimeSlotsModel{
    let eventDate:String
    let timeSlots:NSArray
    
    init?(responceDict:[String:Any]){
        guard let object = responceDict["object"] as? [String:Any] else {
            return nil
        }
        guard let eventDate = object["eventDate"] as? String else {
            return nil
        }
        guard let timeSlots = object["timeSlots"] as? NSArray else {
           return nil
        }
        
        self.eventDate =  eventDate
        self.timeSlots = timeSlots
    }
}
