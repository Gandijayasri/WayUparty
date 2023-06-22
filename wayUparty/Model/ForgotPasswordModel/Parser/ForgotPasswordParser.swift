//
//  ForgotPasswordParser.swift
//  wayUparty
//
//  Created by Arun on 17/02/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import Foundation
class ForgotPasswordParser{
     static func ForgotPasswordAPI(email:String,completion:@escaping(ForgotPasswordCompletion)->Void){
         let constants = Constants()
         var trimmedEmail = email
         trimmedEmail = trimmedEmail.replacingOccurrences(of: " ", with: "")
         let url = "\(constants.baseUrl)/ws/validateEmail?email=\(trimmedEmail)"
         let request = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
         request.httpMethod = "POST"
         URLSession.shared.dataTask(with: request as URLRequest){data,responce,error in
             if error != nil {}
             else{
             do{
             let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
             let closure = try ForgotPasswordCompletion.init(responceDict: result ?? [String:Any] ())
             completion(closure)
             }catch let err as NSError{(print(err))}
           }
         }.resume()
     }
 }
