//
//  GetEventDetailModelParser.swift
//  EventsModule
//
//  Created by Jasty Saran  on 25/12/20.
//

import Foundation
class GetEventDetailModelParser{
    static func GetEventDetailAPI(eventUUID:String,completion:@escaping(EventDetailModelCompletion)->Void){
        let contants = Constants()
        let url = contants.baseUrl + "/ws/getEventDetails?eventUUID=\(eventUUID)"
        let req = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        req.httpMethod = "GET"
        URLSession.shared.dataTask(with: req as URLRequest){data,responce,error in
            if error != nil{
                print(error ?? NSError())
            }else{
                do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                    let closure = try EventDetailModelCompletion.init(reponceDict: result ?? [String:Any]())
                completion(closure)
                } catch let err as NSError {
                    print(err)
                }
            }
        }.resume()
    }
}
