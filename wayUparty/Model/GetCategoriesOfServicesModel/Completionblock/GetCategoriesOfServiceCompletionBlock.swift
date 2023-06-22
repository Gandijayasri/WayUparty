//
//  GetCategoriesOfServiceCompletionBlock.swift
//  wayUparty
//
//  Created by Jasty Saran  on 30/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class GetCategoriesOfCompletionBlock{
    let getCategoriesofService : [GetCategoriesOfServieModel]!
    init(responceDict:[String:Any]) throws{
        var getCategoriesofService = [GetCategoriesOfServieModel]()
        let model = GetCategoriesOfServieModel.init(responceDict: responceDict)
        if model != nil{getCategoriesofService.append(model!)}
        self.getCategoriesofService = getCategoriesofService
    }
}
