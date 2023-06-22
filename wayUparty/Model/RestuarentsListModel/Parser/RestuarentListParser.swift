//
//  RestuarentListParser.swift
//  wayUparty
//
//  Created by Jasty Saran  on 19/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import Foundation
class RestuarentListParser{
    static func getRestuarentsList(Url:String,completion:@escaping(RestuarentListModelCompletionBlock)->Void){
        print("urls:----\(Url)")
        
        let req = NSMutableURLRequest.init(url: NSURL.init(string: Url)! as URL)
        req.httpMethod = "GET"
        URLSession.shared.dataTask(with: req as URLRequest){data,responce,error in
            if error != nil{
                print(error ?? NSError())
            }else{
                do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                    let closure = try RestuarentListModelCompletionBlock.init(responceDict: result ?? [String:Any]())
                    
                completion(closure)
                } catch let err as NSError {
                    print(err)
                }
            }
        }.resume()
    }
   
}

class FilterListParser{
    static func getFilterList(serviceid:String,completion:@escaping(FiltersListModelCompletionBlock)->Void){
        let constants = Constants()
        let url  = constants.baseUrl+"/ws/getServiceCategoriesByServiceId?=&\(serviceid)"
        let req = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        req.httpMethod = "GET"
        URLSession.shared.dataTask(with: req as URLRequest){data,responce,error in
            if error != nil{
                print(error ?? NSError())
            }else{
                do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                    let closure = try FiltersListModelCompletionBlock.init(responceDict: result ?? [String:Any]())
                completion(closure)
                } catch let err as NSError {
                    print(err)
                }
            }
        }.resume()
        
        
    }
}


class TopSpendParser {
    static func getFilterList(completion:@escaping(TopSpendModelCompletionBlock)->Void){
        let constants = Constants()
        let url  = constants.baseUrl+"/ws/getPopularCities?="
        print("\(url)")
        
        let req = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        req.httpMethod = "GET"
        URLSession.shared.dataTask(with: req as URLRequest){data,responce,error in
            if error != nil{
                print(error ?? NSError())
            }else{
                do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                    let closure = try TopSpendModelCompletionBlock.init(responceDict: result ?? [String:Any]())
                completion(closure)
                } catch let err as NSError {
                    print(err)
                }
            }
        }.resume()
        
        
    }
}
//http://13.126.63.133:8080//ws/getAllregisteredRestaurantsList?offset=\(offSet)&limit=\(limit)&latitude=\(latitude)&longitude=\(longitude)&deals=\(deals)
