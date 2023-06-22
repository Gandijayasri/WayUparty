//
//  GetAvaialbleCitiesModel.swift
//  wayUparty
//
//  Created by Jasty Saran  on 24/01/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import Foundation
class GetAvaialbleCitiesModel{
    let cityName:Array<String>
    let cityImage:Array<String>
    let latitude:Array<String>
    let longitude:Array<String>
    
    init?(responceDict:[String:Any]) {
        guard let data = responceDict["data"] as? NSArray else {
            return nil
        }
        guard let cityName = data.value(forKey: "cityName") as? Array<String>  else {
            return nil
        }
        guard let cityImage = data.value(forKey: "cityImage") as? Array<String> else {
            return nil
        }
        guard let latitude = data.value(forKey: "latitude") as? Array<String> else {
            return nil
        }
        guard let longitude = data.value(forKey: "longitude") as? Array<String> else {
            return nil
        }
        
        self.cityName = cityName
        self.cityImage = cityImage
        self.latitude = latitude
        self.longitude = longitude
    }

}
