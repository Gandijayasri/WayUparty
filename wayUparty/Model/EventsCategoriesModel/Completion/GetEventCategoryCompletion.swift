//
//  GetEventCategoryCompletion.swift
//  EventsModule
//
//  Created by Jasty Saran  on 26/12/20.
//

import Foundation
class GetEventCategoryCompletion{
    let getEventCategoryModel : [GetEventCategoriesList]!
    init(responceDict:[String:Any]) throws{
        var getEventCategoryModel = [GetEventCategoriesList]()
        let model = GetEventCategoriesList.init(responceDict: responceDict)
        if model != nil{
            getEventCategoryModel.append(model!)
        }
        self.getEventCategoryModel = getEventCategoryModel
    }
}
