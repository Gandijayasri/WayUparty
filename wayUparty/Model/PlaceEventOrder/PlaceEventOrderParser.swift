//
//  PlaceEventOrderParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 27/12/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class PlaceEventOrderParser{
    static func PlaceEventOrderAPI(xuserName:String,password:String,eventOrderData:[String:Any],completion:@escaping(AddToCartModelCompletionBlock)->Void){
        let constants = Constants()
        let url = "\(constants.baseUrl)/rest/placeEventOrder"
        let request = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        do{request.httpBody = try JSONSerialization.data(withJSONObject: eventOrderData , options: .prettyPrinted)}catch{}
        request.httpMethod = "POST"
        request.setValue(xuserName, forHTTPHeaderField: "X-Username")
        request.setValue(password, forHTTPHeaderField: "X-Password")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request as URLRequest){data,responce,error in
            if error != nil {print(error ?? NSError())}
            else{
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                    let closure = try AddToCartModelCompletionBlock.init(responce: result ?? [String:Any]())
                    completion(closure)
                }catch let err as NSError{print(err)}
            }
        }.resume()
    }
}
