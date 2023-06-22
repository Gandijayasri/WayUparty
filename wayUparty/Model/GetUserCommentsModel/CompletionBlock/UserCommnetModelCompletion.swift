//
//  UserCommnetModelCompletion.swift
//  wayUparty
//
//  Created by Jasty Saran  on 30/01/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import Foundation
class UserCommnetModelCompletion{
    let userCommentModel:[UserCommentModel]!
    init(responceDict:[String:Any]) throws{
        var userCommentModel = [UserCommentModel]()
        let model = UserCommentModel.init(responceDict: responceDict)
        if model != nil{userCommentModel.append(model!)}
        self.userCommentModel = userCommentModel
    }
}
