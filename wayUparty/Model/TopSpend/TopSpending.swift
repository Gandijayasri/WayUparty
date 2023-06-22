//
//  TopSpending.swift
//  wayUparty
//
//  Created by Arun  on 12/05/23.
//  Copyright © 2023 Arun. All rights reserved.
//

import Foundation
struct TopSpendingModel{
   
    let data : NSArray
    var cityName: Array<String>
    
    init?(responceDict:[String:Any]){
        guard let data = responceDict["data"] as? NSArray else {return nil}
        guard let cityName = data.value(forKey:"cityName") as? Array<String> else{return nil}
        
        self.data = data
        self.cityName = cityName
        
    }

}


class TopSpendModelCompletionBlock {
    let topspendList:[TopSpendingModel]!
    init(responceDict:[String:Any]) throws{
        var restuarentList = [TopSpendingModel]()
        let model = TopSpendingModel.init(responceDict: responceDict)
        if model != nil{
            restuarentList.append(model!)
        }
        self.topspendList = restuarentList
    }
    
}
