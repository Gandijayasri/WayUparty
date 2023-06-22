//
//  GetOrdersLisrParser.swift
//  Orders
//
//  Created by Jasty Saran  on 05/11/20.
//

import Foundation
class GetOrdersLisrParser{
    static func getOrdersList(userUUID:String,completion:@escaping(GetOrdersListCompletionBlock)->Void){
        let constants = Constants()
        let url = "\(constants.baseUrl)/rest/getUserOrdersList?userUUID=\(userUUID)"
        print(url)
        
        let request = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        request.httpMethod = "POST"
        request.setValue(constants.xUsername, forHTTPHeaderField: "X-Username")
        request.setValue(constants.xPassword, forHTTPHeaderField: "X-Password")
        URLSession.shared.dataTask(with: request as URLRequest){data,responce,error in
            if error != nil {}
            else{
            do{
            let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
            let closure = try GetOrdersListCompletionBlock.init(responceDict: result ?? [String:Any] ())
            completion(closure)
            }catch let err as NSError{(print(err))}
          }
        }.resume()
    }
}
