//
//  GuestListDetailCompletion.swift
//  wayUparty
//
//  Created by Jasty Saran  on 05/01/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import Foundation
class GuestListDetailCompletion{
    let guestListDetailModel:[GuestListDetailModel]!
    init(responceDict:[String:Any]) throws{
        var guestListDetailModel = [GuestListDetailModel]()
        let model = GuestListDetailModel.init(responceDict: responceDict)
        if model != nil{guestListDetailModel.append(model!)}
        self.guestListDetailModel = guestListDetailModel
    }
}
