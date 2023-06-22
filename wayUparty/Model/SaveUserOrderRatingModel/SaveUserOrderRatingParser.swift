//
//  SaveUserOrderRatingParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 14/02/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import Foundation
import Foundation
class SaveUserOrderRatingParser{
    static func SaveUserOrderRatingAPI(xUsername:String,xPassword:String,userOrderRatingData:[String:Any],completion:@escaping(AddToCartModelCompletionBlock)->Void){
        let constants = Constants()
        let url = "\(constants.baseUrl)/rest/savePlaceOrderRatings"
        let request = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        do{request.httpBody = try JSONSerialization.data(withJSONObject: userOrderRatingData , options: .prettyPrinted)}catch{}
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
