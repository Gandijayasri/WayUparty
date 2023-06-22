//
//  SubmitCodeCompletion.swift
//  wayUparty
//
//  Created by Jasty Saran  on 24/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class SubmitCodeCompletion{
    let submitCodeModel : [SubmitCodeModel]!
    init(responceDict:[String:Any])throws{
        var submitCodeModel = [SubmitCodeModel]()
        let model = SubmitCodeModel.init(responceDict:responceDict)
        if model != nil{
            submitCodeModel.append(model!)
        }
        self.submitCodeModel = submitCodeModel
    }
}
