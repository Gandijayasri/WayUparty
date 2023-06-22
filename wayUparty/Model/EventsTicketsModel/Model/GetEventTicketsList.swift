//
//  GetEventTicketsList.swift
//  EventsModule
//
//  Created by Jasty Saran  on 26/12/20.
//

import Foundation
struct GetEventTicketsList {
    let ticketType:Array<String>
    let ticketAmount:Array<Int>
    let currency:Array<String>
    let maxBookingAllowed:Array<Int>
    let eventUUID:Array<String>
    
    init?(responceDict:[String:Any]){
        guard let data = responceDict["data"] as? NSArray else {
            return nil
        }
        guard let ticketType = data.value(forKey: "ticketType") as? Array<String> else {
            return nil
        }
        guard let ticketAmount = data.value(forKey: "ticketAmount") as? Array<Int> else {
            return nil
        }
        guard let currency = data.value(forKey: "currency") as? Array<String> else {
            return nil
        }
        guard let maxBookingAllowed = data.value(forKey: "maxBookingAllowed") as? Array<Int> else {
            return nil
        }
        guard let eventUUID = data.value(forKey: "eventUUID") as? Array<String> else {
            return nil
        }
        
        self.ticketType = ticketType
        self.ticketAmount = ticketAmount
        self.currency = currency
        self.maxBookingAllowed = maxBookingAllowed
        self.eventUUID = eventUUID
    }
}
