//
//  LoginModelParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 16/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class LoginModelParser{
    static func GetUserLoginDetails(userData:[String:Any],completion:@escaping(LoginCompletionBlock)->Void){
        let constants = Constants()
        let url = "\(constants.baseUrl)/ws/loginRegisteredUser"
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
                    completion(closure)
                }catch let err as NSError{print(err)}
            }
        }.resume()
    }
    static func socialLoginAPIcall(name:String,emailid:String,mobileno:String,completion:@escaping(SocialLogins)->Void){
        let constants = Constants()
        let url = "https://wayuparty.com/ws/saveGoogleUserRegistration?loginUserName=\(name)&email=\(emailid)&mobile=1111111111&password=\(emailid)&confirmPassword=\(emailid)&registrationType=GOOGLE&terms=on"
        let request = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        do{request.httpBody = try JSONSerialization.data(withJSONObject: [] , options: .prettyPrinted)}catch{}
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if let data = data{
                let socialLogin = try? JSONDecoder().decode(SocialLogins.self, from: data)
                if  let responses = socialLogin{
                    completion(responses)
                }
                
            }
        })

        task.resume()
    }
}


import Foundation

struct SocialLogins: Codable {
    let object: JSONNull?
    let error, response, responseMessage: String
}


