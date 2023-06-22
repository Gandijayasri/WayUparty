//
//  SubmitCodeModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 24/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
struct SubmitCodeModel{
    let response: String
    let responseMessage:String
    init?(responceDict:[String:Any]){
        guard let response = responceDict[
        "response"] as? String else {
            return nil
        }
        guard let responseMessage = responceDict["responseMessage"] as? String else {
            return nil
        }
        self.response = response
        self.responseMessage = responseMessage
    }
}
