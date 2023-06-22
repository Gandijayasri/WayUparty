//
//  NetworkAdapator.swift
//  wayUparty
//
//  Created by jayasri on 18/06/23.
//  Copyright © 2023 Arun. All rights reserved.
//

import Foundation
class NetworkAdaptor{
    
    static func request(url:String?,method:HTTPMethod,headers:[String:String]? = nil, urlParameters:[String:String]? = nil, bodyParameter:[String:Any]? = nil, completionHandler:@escaping((Data?, URLResponse?, Error?)-> Void)){
        
        guard var urlString = url else{
            completionHandler(nil, nil, nil)
            return
        }
        
        if let urlParameters = urlParameters{
            let parameteString = (urlParameters.compactMap({ (key, value)-> String in
                return "\(key)=\(value)"
            }) as Array).joined(separator: "&")
            
            urlString = urlString + "?" + parameteString
        }
       
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: urlString) else {
            completionHandler(nil,nil,nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let parameters = bodyParameter{
            do{
                let httpBody = try JSONSerialization.data(withJSONObject: parameters,options: [])
                request.httpBody = httpBody
            }catch{
                completionHandler(nil,nil,nil)
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, respone, error in
            completionHandler(data,respone,error)
        }.resume()
    }
    
}


enum HTTPMethod : String{
    case get
    case post
    case put
    case delete
}
