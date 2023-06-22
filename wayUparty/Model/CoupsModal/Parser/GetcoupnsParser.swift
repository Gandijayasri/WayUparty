//
//  GetcoupnsParser.swift
//  wayUparty
//
//  Created by Arun on 06/04/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import Foundation
class GetcoupnsParser{
    static func GetAvaialblecoupnsAPI(completion:@escaping(GetcoupnsCompletionBlock)->Void){
        let contants = Constants()
        let url = contants.baseUrl + "/ws/getCouponList"
        
        let req = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        req.httpMethod = "GET"
       
        URLSession.shared.dataTask(with: req as URLRequest){data,responce,error in
            if error != nil{
                print(error ?? NSError())
            }else{
                do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                    let closure = try GetcoupnsCompletionBlock.init(responseDict: result ?? [String:Any]())
                completion(closure)
                } catch let err as NSError {
                    print(err)
                }
            }
        }.resume()
    }
}
