//
//  GuestListDetailModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 05/01/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import Foundation
struct GuestListDetailModel {
    let club:String
    let clubLocation:String
    let clubImage:String
    let guestDate:String
    let guestCode:String
    let description:String
    let qrCode:String
    
    init?(responceDict:[String:Any]){
        guard let object = responceDict["object"] as?  [String:Any] else {
            return nil
        }
        guard let club = object["club"] as? String else {
            return nil
        }
        guard let clubLocation = object["clubLocation"] as? String else {
            return nil
        }
        guard let clubImage = object["clubImage"] as? String else {
            return nil
        }
        guard let guestDate = object["guestDate"] as? String else {
            return nil
        }
        guard let guestCode = object["guestCode"] as? String else {
            return nil
        }
        guard let description = object["description"] as? String else {
            return nil
        }
        guard let qrCode = object["qrCode"] as? String else {
            return nil
        }
        
        self.club = club
        self.clubImage = clubImage
        self.clubLocation = clubLocation
        self.guestDate = guestDate
        self.guestCode = guestCode
        self.description = description
        self.qrCode = qrCode
    }
}
