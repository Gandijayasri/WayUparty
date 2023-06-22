//
//  RemoveParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 16/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class RemoveCartItemParser{
    static func RemoveItemFromCartWith(xUsername:String,xPassword:String,cartUUID:String,completion:@escaping(AddToCartModelCompletionBlock)->Void){
        let constants = Constants()
        let url = "\(constants.baseUrl)/rest/removeCartItem?cartUUID=\(cartUUID)"
        let request = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        request.httpMethod = "POST"
        request.setValue(xUsername, forHTTPHeaderField: "X-Username")
        request.setValue(xPassword, forHTTPHeaderField: "X-Password")
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
