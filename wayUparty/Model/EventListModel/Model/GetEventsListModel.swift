//
//  GetEventsListModel.swift
//  EventsModule
//
//  Created by Jasty Saran  on 25/12/20.
//

import Foundation
struct GetEventListModel {
    let eventName:Array<String>
    let eventLocation:Array<String>
    let date:Array<Int>
    let time:Array<String>
    let day:Array<String>
    let month:Array<String>
    let eventImage:Array<String>
    let eventUUID:Array<String>
    let eventDate:Array<String>
    let eventHost:Array<String>
    
    init?(responceDict:[String:Any]){
        guard let data = responceDict["data"] as? NSArray else{return nil}
        guard let eventName = data.value(forKey: "eventName") as? Array<String> else {
            return nil
        }
        guard let eventLocation = data.value(forKey: "eventLocation") as? Array<String> else {
            return nil
        }
        guard let date = data.value(forKey: "date") as? Array<Int> else {
            return nil
        }
        guard let time = data.value(forKey: "time") as? Array<String> else {
            return nil
        }
        guard let day = data.value(forKey: "day") as? Array<String> else {
            return nil
        }
        guard let month = data.value(forKey: "month") as? Array<String> else {
            return nil
        }
        guard let eventImage = data.value(forKey: "eventImage") as? Array<String> else {
            return nil
        }
        guard let eventUUID = data.value(forKey: "eventUUID") as? Array<String> else {
            return nil
        }
        guard let eventDate = data.value(forKey: "eventDate") as? Array<String> else {
            return nil
        }
        guard let eventHost = data.value(forKey: "eventHost") as? Array<String> else {
            return nil
        }
        
        self.eventName = eventName
        self.eventLocation = eventLocation
        self.date = date
        self.time = time
        self.day = day
        self.month = month
        self.eventImage = eventImage
        self.eventUUID = eventUUID
        self.eventDate = eventDate
        self.eventHost = eventHost
    }
}
