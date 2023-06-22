//
//  RestuarentsDetailsModelCompletionBlock.swift
//  wayUparty
//
//  Created by Jasty Saran  on 20/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class RestuarentDetailsModelCompletionBlock{
    let restuarentDetailsModel : [RestuarentDetailsModel]!
    init(responceDict:[String:Any]) throws{
        var restuarentDetailsmodel = [RestuarentDetailsModel]()
        let model = RestuarentDetailsModel.init(responceDict: responceDict)
        if model != nil{restuarentDetailsmodel.append(model!)}
        self.restuarentDetailsModel = restuarentDetailsmodel
    }
}
