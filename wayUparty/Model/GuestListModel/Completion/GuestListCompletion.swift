//
//  GuestListCompletion.swift
//  wayUparty
//
//  Created by Jasty Saran  on 05/01/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import Foundation
class GuestListCompletion{
    let guestListModel:[GuestListModel]!
    init(responceDict:[String:Any]) throws{
        var guestListModel = [GuestListModel]()
        let model = GuestListModel.init(responceDict: responceDict)
        if model != nil{guestListModel.append(model!)}
        self.guestListModel = guestListModel
    }
}
