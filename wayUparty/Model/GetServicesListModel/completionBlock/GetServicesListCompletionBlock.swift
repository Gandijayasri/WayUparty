//
//  GetServicesListCompletionBlock.swift
//  wayUparty
//
//  Created by Jasty Saran  on 01/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class GetServicesListCompletionBlock{
    let getServicesListModel: [GetServicesListModel]!
    init(responceDict:[String:Any])throws{
      var getServicesListModel = [GetServicesListModel]()
        let model = GetServicesListModel.init(responceDict: responceDict)
        if model != nil{getServicesListModel.append(model!)}
        self.getServicesListModel = getServicesListModel
    }
}
