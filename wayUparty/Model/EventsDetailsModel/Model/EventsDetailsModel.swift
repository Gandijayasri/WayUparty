//
//  EventsDetailsModel.swift
//  EventsModule
//
//  Created by Jasty Saran  on 25/12/20.
//

import Foundation
struct EventDetailsModel{
    let eventName:String
    let eventType:String
    let eventHost:String
    let eventDate:String
    let address:String
    let language:String
    let age:String
    let minimumStartingAmount:String
    let eventImage:String
    let duration:String
    let musicType:String
    let eventUUID:String
    
    init?(responceDict:[String:Any]){
        guard let object = responceDict["object"] as? [String:Any] else{return nil}
        guard let eventName = object["eventName"] as? String else{return nil}
        guard let eventType = object["eventType"] as? String else{return nil}
        guard let eventHost = object["eventHost"] as? String else{return nil}
        guard let eventDate = object["eventDate"] as? String else{return nil}
        guard let address = object["address"] as? String else{return nil}
        guard let language = object["language"] as? String else{return nil}
        guard let age = object["age"] as? String else{return nil}
        guard let minimumStartingAmount = object["minimumStartingAmount"] as? String else{return nil}
        guard let eventImage = object["eventImage"] as? String else{return nil}
        guard let duration = object["duration"] as? String else{return nil}
        guard let musicType = object["musicType"] as? String else{return nil}
        guard let eventUUID = object["eventUUID"] as? String else{return nil}
        
        
        self.eventName = eventName
        self.eventType = eventType
        self.eventHost = eventHost
        self.eventDate = eventDate
        self.address = address
        self.language = language
        self.eventImage = eventImage
        self.eventUUID = eventUUID
        self.age = age
        self.minimumStartingAmount = minimumStartingAmount
        self.duration = duration
        self.musicType = musicType
        
        
    }
}
