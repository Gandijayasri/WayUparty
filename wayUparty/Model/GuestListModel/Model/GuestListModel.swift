//
//  GuestListModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 05/01/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import Foundation
struct GuestListModel{
    let club:Array<String>
    let clubLocation:Array<String>
    let clubImage:Array<String>
    let guestUUID:Array<String>
    
    init?(responceDict:[String:Any]){
        guard let data = responceDict["data"] as?  NSArray else {
            return nil
        }
        guard let club = data.value(forKey:"club") as? Array<String> else {
            return nil
        }
        guard let clubLocation = data.value(forKey:"clubLocation") as? Array<String> else {
            return nil
        }
        guard let clubImage = data.value(forKey:"clubImage") as? Array<String> else {
            return nil
        }
        guard let guestUUID = data.value(forKey:"guestUUID") as? Array<String> else {
            return nil
        }
        
        self.club = club
        self.clubImage = clubImage
        self.clubLocation = clubLocation
        self.guestUUID = guestUUID
    }
}
