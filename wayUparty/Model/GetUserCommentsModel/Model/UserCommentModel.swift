//
//  UserCommentModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 30/01/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import Foundation
struct UserCommentModel{
    let userName:Array<String>
    let rating:Array<Int>
    let ratingDescription:Array<String>
    let createdDate:Array<String>
    let createdTime:Array<String>
    
    init?(responceDict:[String:Any]){
        guard let data = responceDict["data"] as? NSArray else {
            return nil
        }
        guard let rating = data.value(forKey: "rating") as? Array<Int> else {
            return nil
        }
        guard let userName = data.value(forKey: "userName") as? Array<String> else {
            return nil
        }
        guard let ratingDescription = data.value(forKey: "ratingDescription") as? Array<String> else {
            return nil
        }
        guard let createdDate = data.value(forKey: "createdDate") as? Array<String> else {
            return nil
        }
        guard let createdTime = data.value(forKey: "createdTime") as? Array<String> else {
            return nil
        }
        
        self.userName = userName
        self.rating  =  rating
        self.createdDate = createdDate
        self.createdTime = createdTime
        self.ratingDescription =  ratingDescription
    }
}
