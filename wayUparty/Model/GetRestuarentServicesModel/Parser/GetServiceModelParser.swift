//
//  GetServiceModelParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 30/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class GetServiceModelParser{
    static func GetServicesListAPI(vendorUUID:String,completionBlock:@escaping(GetServicesModelCompletionBlock)->Void){
        let contants = Constants()
        let url = contants.baseUrl + "/ws/getServicesList?vendorUUID=\(vendorUUID)"
        print("servicesurl\(url)")
        let req = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        req.httpMethod = "GET"
        URLSession.shared.dataTask(with: req as URLRequest){data,responce,error in
            if error != nil{
                print(error ?? NSError())
            }else{
                do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                let closure = try GetServicesModelCompletionBlock.init(responceDict: result ?? [String:Any]())
                completionBlock(closure)
                } catch let err as NSError {
                    print(err)
                }
            }
        }.resume()
    }
}
