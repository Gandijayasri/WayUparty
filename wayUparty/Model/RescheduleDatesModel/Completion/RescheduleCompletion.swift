//
//  RescheduleCompletion.swift
//  wayUparty
//
//  Created by Jasty Saran  on 17/12/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class RescheduleCompletion{
    let rescheduleModel : [RescheduleModel]!
    init(responceDict:[String:Any]) throws{
        var rescheduleModel = [RescheduleModel]()
        let model = RescheduleModel.init(responceDict: responceDict)
        if model != nil{
            rescheduleModel.append(model!)}
        self.rescheduleModel = rescheduleModel
    }
}
