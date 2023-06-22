//
//  AddToCartModelCompletionBlock.swift
//  wayUparty
//
//  Created by Jasty Saran  on 16/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class AddToCartModelCompletionBlock{
    let addToCartModel : [AddToCartModel]!
    init(responce:[String:Any]) throws{
        var addToCartModel = [AddToCartModel]()
        let model = AddToCartModel.init(responceDict: responce)
        if model != nil{
            addToCartModel.append(model!)
        }
        self.addToCartModel = addToCartModel
    }
}
