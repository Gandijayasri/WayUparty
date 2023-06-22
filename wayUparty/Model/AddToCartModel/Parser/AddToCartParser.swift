//
//  AddToCartParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 16/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class AddToCartParser{
    static func AddToCartParser(cartData:[String:Any],xUsername:String,xPassword:String,completionBlock:@escaping(AddToCartModelCompletionBlock)->Void){
        let constants = Constants()
        let url = "\(constants.baseUrl)/rest/addToCart"
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
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                   // let resu = try JSONSerialization.js
                    
                    let closure = try AddToCartModelCompletionBlock.init(responce: result ?? [String:Any]())
                    completionBlock(closure)
                }catch let err as NSError{print(err)}
            }
        }.resume()
    }
}
