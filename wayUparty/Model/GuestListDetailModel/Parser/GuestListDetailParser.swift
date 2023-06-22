//
//  GuestListParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 05/01/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import Foundation
class GuestListDetailParser{
    static func GuestListDetailParserAPI(guestUUID:String,completion:@escaping(GuestListDetailCompletion)->Void){
        let contants = Constants()
        let url = contants.baseUrl + "/rest/getGuestClubDetails?guestUUID=\(guestUUID)"
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
                    let closure = try GuestListDetailCompletion.init(responceDict: result ?? [String:Any]())
                completion(closure)
                } catch let err as NSError {
                    print(err)
                }
            }
        }.resume()
    }
}
