//
//  GetOrdersListCompletionBlock.swift
//  Orders
//
//  Created by Jasty Saran  on 05/11/20.
//

import Foundation
class GetOrdersListCompletionBlock{
    let getOrderListModel : [GetOrderListModel]!
    init(responceDict:[String:Any]) throws{
        var getOrdersListModel = [GetOrderListModel]()
        let model = GetOrderListModel.init(responceDict: responceDict)
        if model != nil{
            getOrdersListModel.append(model!)
        }
        self.getOrderListModel = getOrdersListModel
    }
}
