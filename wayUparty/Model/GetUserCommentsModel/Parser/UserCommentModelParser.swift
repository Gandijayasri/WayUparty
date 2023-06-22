//
//  UserCommentModelParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 30/01/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import Foundation
class  UserCommentModelParser{
    static func UserCommentModelParserAPI(xUsername:String,xPassword:String,vendorUUID:String,completion:@escaping(UserCommnetModelCompletion)->Void){
        let contants = Constants()
        let url = contants.baseUrl + "/rest/getVendorRatings?vendorUUID=\(vendorUUID)&offSet=0&limit=100"
        let req = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        req.httpMethod = "GET"
        req.addValue(contants.xUsername, forHTTPHeaderField: "X-Username")
        req.addValue(contants.xPassword, forHTTPHeaderField: "X-Password")
        URLSession.shared.dataTask(with: req as URLRequest){data,responce,error in
            if error != nil{
                print(error ?? NSError())
            }else{
                do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                let closure = try UserCommnetModelCompletion.init(responceDict: result ?? [String:Any]())
                completion(closure)
                } catch let err as NSError {
                    print(err)
                }
            }
        }.resume()
    }
}
