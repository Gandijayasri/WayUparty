//
//  RescheduleModelParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 17/12/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class RescheduleModelParser{
    static func RescheduleOrderAPI(xUsername:String,xPassword:String,orderItemUUID:String,completion:@escaping(RescheduleCompletion)->Void){
        let constants = Constants()
        let url = "\(constants.baseUrl)/rest/getRescheduleDetails?orderUUID=\(orderItemUUID)"
        let request = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        request.httpMethod = "GET"
        request.setValue(xUsername, forHTTPHeaderField: "X-Username")
        request.setValue(xPassword, forHTTPHeaderField: "X-Password")
        URLSession.shared.dataTask(with: request as URLRequest){data,responce,error in
            if error != nil {}
            else{
            do{
            let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
            let closure = try RescheduleCompletion.init(responceDict: result ?? [String:Any] ())
            completion(closure)
            }catch let err as NSError{(print(err))}
          }
        }.resume()
    }
}
