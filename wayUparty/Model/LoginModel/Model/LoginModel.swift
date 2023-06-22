//
//  LoginModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 16/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
struct LoginModel {
    let response : String
    let loginUserName: String
    let userUUID: String
    let userEmail: String
    let userMobile: String
    let responseMessage:String
    let preferredDrinksList:Array<String>
    let preferredMusicList:Array<String>
    let gender:String
    let preferredDrinks:String
    let preferredMusic:String
    let userImage:String
    let dob:String
    
    init?(responceDict:[String:Any]){
        guard let object = responceDict["object"] as? [String:Any] else{return nil}
        guard let responseMessage = responceDict["responseMessage"] as? String else{return nil}
        guard let response = responceDict["response"] as? String else{return nil}
        guard let loginUserName = object["loginUserName"] as? String else{return nil}
        guard let dob = object["dob"] as? String else{return nil}
        guard let preferredDrinksList = object["preferredDrinksList"] as? Array<String> else{return nil}
        guard let userImage = object["userImage"] as? String else{return nil}
        guard let preferredDrinks = object["preferredDrinks"] as? String else{return nil}
        guard let gender = object["gender"] as? String else{return nil}
        guard let preferredMusic = object["preferredMusic"] as? String else {return nil}
        guard let preferredMusicList = object["preferredMusicList"] as? Array<String> else{return nil}
        guard let userUUID = object["userUUID"] as? String else{return nil}
        guard let userEmail = object["userEmail"] as? String else{return nil}
        guard let userMobile = object["userMobile"] as? String else{return nil}
        
        self.response = response
        self.loginUserName = loginUserName
        self.userUUID = userUUID
        self.userEmail = userEmail
        self.userMobile = userMobile
        self.responseMessage = responseMessage
        self.preferredDrinksList = preferredDrinksList
        self.preferredMusicList = preferredMusicList
        self.gender = gender
        self.preferredDrinks = preferredDrinks
        self.preferredMusic = preferredMusic
        self.userImage = userImage
        self.dob = dob
    }
    
}
