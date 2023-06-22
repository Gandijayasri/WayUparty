//
//  ForgetModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 24/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
struct ForgotModel{
    let verificationUUID:String
    let response : String
    let responseMessage: String
    init?(responceDict:[String:Any]){
        guard let object = responceDict["object"] as? [String:Any] else{return nil}
        guard let verificationUUID = object["verificationUUID"] as? String else {
            return nil
        }
        guard let response = responceDict["response"] as? String else {
            return nil
        }
        guard let responseMessage = responceDict["responseMessage"] as? String else {
            return nil
        }
        self.verificationUUID = verificationUUID
        self.response = response
        self.responseMessage = responseMessage
    }
}
