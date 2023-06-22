//
//  GenerateOrderIDParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 13/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class GenerateOrderIDParser{
    static func RazorpayGenerateOrderAPI(xUsername:String,xPassword:String,patymentInfo:[String:Any],completion:@escaping(GetOrderIDModelCompletion)->Void){
        let constants = Constants()
        let url = "\(constants.baseUrl)/rest/orders"
        let request = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        do{request.httpBody = try JSONSerialization.data(withJSONObject: patymentInfo , options: .prettyPrinted)}catch{}
        request.httpMethod = "POST"
        request.setValue(xUsername, forHTTPHeaderField: "X-Username")
        request.setValue(xPassword, forHTTPHeaderField: "X-Password")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request as URLRequest){data,responce,error in
            if error != nil {print(error ?? NSError())}
            else{
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                    let closure = try GetOrderIDModelCompletion.init(responceDict: result ?? [String:Any]())
                    completion(closure)
                }catch let err as NSError{print(err)}
            }
        }.resume()
    }
}
