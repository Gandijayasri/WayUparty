//
//  RestuarentDetailsModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 19/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
struct RestuarentDetailsModel{
    var vendorCapacity:Int
    var establishedYear:Int
    var vendorMobile:String
    var location:String
    var vendorAddress:String
    var categoriesList:NSArray
    var facilitiesList:NSArray
    var musicList:NSArray
    var cuisineList:NSArray
    var workingHoursList:NSArray
    var menuList:NSArray
    var sliderList:NSArray
    var galleryList:NSArray
    var videoList:NSArray
    var termsAndConditions:String
    
    init?(responceDict:[String:Any]){
        guard let object = responceDict["object"] as? [String:Any] else {return nil}
        guard let vendorMobile = object["vendorMobile"] as? String else{return nil}
        guard let vendorCapacity = object["vendorCapacity"] as? Int else{return nil}
        guard let establishedYear = object["establishedYear"] as? Int else{return nil}
        guard let location = object["location"] as? String else{return nil}
        guard let vendorAddress = object["vendorAddress"] as? String else{return nil}
        guard let categoriesList = object["categoriesList"] as? NSArray else{return nil}
        guard let facilitiesList = object["facilitiesList"] as? NSArray else{return nil}
        guard let musicList = object["musicList"] as? NSArray else{return nil}
        guard let cuisineList = object["cuisineList"] as? NSArray else{return nil}
        guard let workingHoursList = object["workingHoursList"] as? NSArray else{return nil}
        guard let menuList = object["menuList"] as? NSArray else{return nil}
        guard let sliderList = object["sliderList"] as? NSArray else{return nil}
        guard let galleryList = object["galleryList"] as? NSArray else{return nil}
        guard let videoList = object["videoList"] as? NSArray else{return nil}
        guard let termsandcondition = object["termsAndConditions"] as? String else{return nil}
        
        self.vendorCapacity = vendorCapacity
        self.establishedYear = establishedYear
        self.vendorMobile = vendorMobile
        self.location = location
        self.vendorAddress = vendorAddress
        self.categoriesList = categoriesList
        self.facilitiesList = facilitiesList
        self.musicList = musicList
        self.cuisineList = cuisineList
        self.workingHoursList = workingHoursList
        self.menuList = menuList
        self.sliderList = sliderList
        self.galleryList = galleryList
        self.videoList = videoList
        self.termsAndConditions = termsandcondition
    }
}
