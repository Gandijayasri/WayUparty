//
//  EventsDetailModelCompletion.swift
//  EventsModule
//
//  Created by Jasty Saran  on 25/12/20.
//

import Foundation
class EventDetailModelCompletion{
    let eventDetailModel : [EventDetailsModel]!
    init(reponceDict:[String:Any]) throws{
        var eventDetailModel = [EventDetailsModel]()
        let model = EventDetailsModel.init(responceDict: reponceDict)
        if model != nil{
            eventDetailModel.append(model!)
        }
        self.eventDetailModel = eventDetailModel
    }
}
