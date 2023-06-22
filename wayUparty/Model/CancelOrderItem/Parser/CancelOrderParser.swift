//
//  CancelOrderParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 13/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class CancelOrderParser{
    static func CancelOrderAPI(xUsername:String,xPassword:String,orderUUID:String,completion:@escaping(AddToCartModelCompletionBlock)->Void){
        let constants = Constants()
        let url = "\(constants.baseUrl)/rest/cancelOrder?orderUUID=\(orderUUID)"
        let request = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        request.httpMethod = "POST"
        request.setValue(constants.xUsername, forHTTPHeaderField: "X-Username")
        request.setValue(constants.xPassword, forHTTPHeaderField: "X-Password")
        URLSession.shared.dataTask(with: request as URLRequest){data,responce,error in
            if error != nil {}
            else{
            do{
            let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                let closure = try AddToCartModelCompletionBlock.init(responce: result ?? [String:Any] ())
            completion(closure)
            }catch let err as NSError{(print(err))}
          }
        }.resume()
    }
}
