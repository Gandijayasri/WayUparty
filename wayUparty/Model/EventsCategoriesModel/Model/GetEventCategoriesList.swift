//
//  GetEventCategoriesList.swift
//  EventsModule
//
//  Created by Jasty Saran  on 26/12/20.
//

import Foundation
struct GetEventCategoriesList{
    let categoryName:Array<String>
    let minimumCost:Array<Int>
    let currency:Array<String>
    let eventUUID:Array<String>
    let categoryType:Array<String>
    
    init?(responceDict:[String:Any]){
        guard let data = responceDict["data"] as? NSArray else{return nil}
        guard let categoryName = data.value(forKey: "categoryName") as? Array<String> else{return nil}
        guard let minimumCost = data.value(forKey: "minimumCost") as? Array<Int> else{return nil}
        guard let currency = data.value(forKey: "categoryName") as? Array<String> else{return nil}
        guard let eventUUID = data.value(forKey: "eventUUID") as? Array<String> else{return nil}
        guard let categoryType = data.value(forKey: "categoryType") as? Array<String> else{return nil}
        
        self.categoryName = categoryName
        self.minimumCost = minimumCost
        self.currency = currency
        self.eventUUID = eventUUID
        self.categoryType = categoryType
    }
}
