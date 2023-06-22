//
//  SubmitCodeModelParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 24/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class SubmitCodeModelParser{
    static func SubmitCodeAPI(verificationData:[String:Any],completion:@escaping(SubmitCodeCompletion)->Void){
        let constants = Constants()
        let url = "\(constants.baseUrl)/ws/resetLoginUserPassword"
        let request = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        do{request.httpBody = try JSONSerialization.data(withJSONObject: verificationData , options: .prettyPrinted)}catch{}
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request as URLRequest){data,responce,error in
            if error != nil {print(error ?? NSError())}
            else{
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                    let closure = try SubmitCodeCompletion.init(responceDict: result ?? [String:Any]())
                    completion(closure)
                }catch let err as NSError{print(err)}
            }
        }.resume()
    }
}
