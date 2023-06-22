//
//  GetCategoriesOfServieModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 30/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class GetCategoriesOfServieModel{
    let data:NSArray
    let categoryId: NSArray
    let categoryName: NSArray
    let categoryUUID: NSArray
    
    init?(responceDict:[String:Any]){
        guard let data = responceDict["data"] as? NSArray else{return nil}
        guard let categoryId = data.value(forKey: "categoryId") as? NSArray else{return nil}
        guard let categoryName = data.value(forKey: "categoryName") as? NSArray else{return nil}
        guard let categoryUUID = data.value(forKey: "categoryUUID") as? NSArray else{return nil}
        
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.categoryUUID = categoryUUID
        self.data = data
        
    }
}
