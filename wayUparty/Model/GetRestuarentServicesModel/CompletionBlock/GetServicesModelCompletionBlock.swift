//
//  GetServicesModelCompletionBlock.swift
//  wayUparty
//
//  Created by Jasty Saran  on 30/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class GetServicesModelCompletionBlock{
    let getServicesModel : [GetServicesModel]!
    init(responceDict:[String:Any]) throws{
        var getServiceModel = [GetServicesModel]()
        let model = GetServicesModel.init(responceDict: responceDict)
        if model != nil{getServiceModel.append(model!)}
        self.getServicesModel = getServiceModel
    }
}
