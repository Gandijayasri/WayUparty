//
//  EventTimeSlotsCompletion.swift
//  EventsModule
//
//  Created by Jasty Saran  on 25/12/20.
//

import Foundation
class EventTimeSlotsCompletion{
    let eventTimeSlotModel : [EventTimeSlotsModel]!
    init(responceDict:[String:Any]) throws{
        var eventTimeSlotModel = [EventTimeSlotsModel]()
        let model = EventTimeSlotsModel.init(responceDict: responceDict)
        if model != nil {
            eventTimeSlotModel.append(model!)
        }
        self.eventTimeSlotModel = eventTimeSlotModel
    }
}
