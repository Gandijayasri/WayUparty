//
//  RestuarentDetailsModelParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 20/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class RestuarentDetailsModelParser{
static func getRestuarentsListDetails(uuid:String,completion:@escaping(RestuarentDetailsModelCompletionBlock)->Void){
        let contants = Constants()
        let url = contants.baseUrl + "/ws/getVendorInfo?vendorUUID=\(uuid)"
    print("printurl:----->\(url)")
    
        let req = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        req.httpMethod = "GET"
        URLSession.shared.dataTask(with: req as URLRequest){data,responce,error in
            if error != nil{
                print(error ?? NSError())
            }else{
                do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                let closure = try RestuarentDetailsModelCompletionBlock.init(responceDict: result ?? [String:Any]())
                completion(closure)
                } catch let err as NSError {
                    print(err)
                }
            }
        }.resume()
    }

}
