//
//  GetCartListCompletionBlock.swift
//  wayUparty
//
//  Created by Jasty Saran  on 16/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class GetCartListCompletionBlock{
    let cartListModel : [GetCartListModel]!
    init(responceDict:[String:Any])throws{
        var cartListModel = [GetCartListModel]()
        let model = GetCartListModel.init(responceDict: responceDict)
        if model != nil{
            cartListModel.append(model!)
        }
        self.cartListModel = cartListModel
    }
}
