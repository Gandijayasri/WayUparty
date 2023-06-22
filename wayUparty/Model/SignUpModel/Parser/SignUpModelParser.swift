//
//  SignUpModelParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 24/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class SignUpModelParser{
    static func SignUPAPI(userData:[String:Any],COMPLETION:@escaping(LoginCompletionBlock)->Void){
        let constants = Constants()
        let url = "\(constants.baseUrl)/ws/signupUser"
        let request = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        do{request.httpBody = try JSONSerialization.data(withJSONObject: userData , options: .prettyPrinted)}catch{}
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request as URLRequest){data,responce,error in
            if error != nil {print(error ?? NSError())}
            else{
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                    let closure = try LoginCompletionBlock.init(responce: result ?? [String:Any]())
                    COMPLETION(closure)
                }catch let err as NSError{print(err)}
            }
        }.resume()
    }
}
