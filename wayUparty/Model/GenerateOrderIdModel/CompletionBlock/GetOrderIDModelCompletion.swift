//
//  GetOrderIDModelCompletion.swift
//  wayUparty
//
//  Created by Jasty Saran  on 13/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class GetOrderIDModelCompletion{
    let getOrderIdModel : [GenerateOrderIDModel]!
    init(responceDict:[String:Any]) throws{
        var getOrderIdModel = [GenerateOrderIDModel]()
        let model = GenerateOrderIDModel.init(responceDict: responceDict)
        if model != nil{
            getOrderIdModel.append(model!)
        }
        self.getOrderIdModel = getOrderIdModel

    }
}
