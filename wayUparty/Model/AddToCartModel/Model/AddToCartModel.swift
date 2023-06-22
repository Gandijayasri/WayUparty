//
//  AddToCartModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 16/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
struct AddToCartModel {
    let responce : String
    let responseMessage:Any
    init?(responceDict:[String:Any]){
        guard let responce = responceDict["response"] as? String else{return nil}
        let responseMessage = responceDict["responseMessage"] as Any
        self.responce = responce
        self.responseMessage = responseMessage
    }
}
