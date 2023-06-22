//
//  GetAvaialbleCitiesCompletionBlock.swift
//  wayUparty
//
//  Created by Jasty Saran  on 24/01/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import Foundation
class GetAvaialbleCitiesCompletionBlock{
    let getAvaialbleCitiesModel:[GetAvaialbleCitiesModel]!
    init(responceDict:[String:Any]) throws{
        var getAvaialbleCitiesModel = [GetAvaialbleCitiesModel]()
        let model = GetAvaialbleCitiesModel.init(responceDict: responceDict)
        if model != nil{getAvaialbleCitiesModel.append(model!)}
        self.getAvaialbleCitiesModel = getAvaialbleCitiesModel
    }
}
