//
//  GetEventsCompletionBlock.swift
//  EventsModule
//
//  Created by Jasty Saran  on 25/12/20.
//

import Foundation
class GetEventsCompletionBlock{
    let getEventsmodel : [GetEventListModel]!
    init(responceDict:[String:Any]) throws{
      var getEventsmodel = [GetEventListModel]()
        let model = GetEventListModel.init(responceDict: responceDict)
        if model != nil{
            getEventsmodel.append(model!)
        }
        self.getEventsmodel = getEventsmodel
    }
}
