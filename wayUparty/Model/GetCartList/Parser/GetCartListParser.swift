//
//  GetCartListParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 16/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class GetCartListParser{
    static func GetcartList(useruuid:String,xUsername:String,xPassword:String,completion:@escaping(GetCartListCompletionBlock)->Void){
        let constants = Constants()
        let url = "\(constants.baseUrl)/rest/getCartList?userUUID=\(useruuid)"
        print("carturl:------>\(url)")
        
        let request = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        request.httpMethod = "GET"
        request.setValue(xUsername, forHTTPHeaderField: "X-Username")
        request.setValue(xPassword, forHTTPHeaderField: "X-Password")
        
        URLSession.shared.dataTask(with: request as URLRequest){data,responce,error in
            if error != nil {}
            else{
            do{
            let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
            let closure = try GetCartListCompletionBlock.init(responceDict: result ?? [String:Any] ())
            completion(closure)
            }catch let err as NSError{(print(err))}
          }
        }.resume()
    }
}
