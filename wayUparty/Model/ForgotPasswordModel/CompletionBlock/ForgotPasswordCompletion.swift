//
//  ForgotPasswordCompletion.swift
//  wayUparty
//
//  Created by Jasty Saran  on 24/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class ForgotPasswordCompletion{
    let forgotModel : [ForgotModel]!
    init(responceDict:[String:Any]) throws{
        var forgetModel = [ForgotModel]()
        let model = ForgotModel.init(responceDict: responceDict)
        if model != nil{
            forgetModel.append(model!)
        }
        self.forgotModel = forgetModel
    }
}
