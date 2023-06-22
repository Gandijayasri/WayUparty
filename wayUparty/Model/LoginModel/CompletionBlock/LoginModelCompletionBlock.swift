//
//  LoginModelCompletionBlock.swift
//  wayUparty
//
//  Created by Jasty Saran  on 16/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class LoginCompletionBlock{
    let loginModel : [LoginModel]!
    init(responce:[String:Any]) throws{
        var loginModel = [LoginModel]()
        let model = LoginModel.init(responceDict: responce)
        if model != nil{
            loginModel.append(model!)
        }
        self.loginModel = loginModel
    }
}
