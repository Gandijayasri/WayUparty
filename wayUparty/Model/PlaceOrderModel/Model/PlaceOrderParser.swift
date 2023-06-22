//
//  PlaceOrderParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 29/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class PlaceOrderParser{
    static func PlaceOrderWithCartUUIDs(xUsername:String,xPassword:String,cartData:[String:Any],completion:@escaping(AddToCartModelCompletionBlock)->Void){
        let constants = Constants()
        let url = "\(constants.baseUrl)/rest/placeOrder"
        let request = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        do{request.httpBody = try JSONSerialization.data(withJSONObject: cartData , options: .prettyPrinted)}catch{}
        request.httpMethod = "POST"
        request.setValue(xUsername, forHTTPHeaderField: "X-Username")
        request.setValue(xPassword, forHTTPHeaderField: "X-Password")
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
