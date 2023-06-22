//
//  RestuarentListModelCompletionBlock.swift
//  wayUparty
//
//  Created by Jasty Saran  on 19/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class RestuarentListModelCompletionBlock{
    let restuarentList : [RestuarentListModel]!
    init(responceDict:[String:Any]) throws{
        var restuarentList = [RestuarentListModel]()
        let model = RestuarentListModel.init(responceDict: responceDict)
        if model != nil{
            restuarentList.append(model!)
        }
        self.restuarentList = restuarentList
    }
}

class FiltersListModelCompletionBlock {
    let filterList:[FiltersListModel]!
    init(responceDict:[String:Any]) throws{
        var restuarentList = [FiltersListModel]()
        let model = FiltersListModel.init(responceDict: responceDict)
        if model != nil{
            restuarentList.append(model!)
        }
        self.filterList = restuarentList
    }
    
}
