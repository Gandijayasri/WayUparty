//
//  GetEventTicketListCompletion.swift
//  EventsModule
//
//  Created by Jasty Saran  on 26/12/20.
//

import Foundation
class GetEventTicketListCompletion{
    let getEventTicketList : [GetEventTicketsList]!
    init(responceDict:[String:Any]) throws{
        var getEventTicketList = [GetEventTicketsList]()
        let model = GetEventTicketsList.init(responceDict:responceDict)
        if model != nil{
            getEventTicketList.append(model!)
        }
        self.getEventTicketList = getEventTicketList
    }
    
}
