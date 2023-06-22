//
//  GetEventTicketListParser.swift
//  EventsModule
//
//  Created by Jasty Saran  on 26/12/20.
//

import Foundation
class GetEventTicketListParser {
    static func GetEventTicketListAPI(eventUUID:String,categoryType:String,completion:@escaping(GetEventTicketListCompletion)->Void){
        let contants = Constants()
        let url = contants.baseUrl + "/ws/getEventTickets?eventUUID=\(eventUUID)&categoryType=\(categoryType)"
        let req = NSMutableURLRequest.init(url: NSURL.init(string: url)! as URL)
        req.httpMethod = "GET"
        URLSession.shared.dataTask(with: req as URLRequest){data,responce,error in
            if error != nil{
                print(error ?? NSError())
            }else{
                do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                    let closure = try GetEventTicketListCompletion.init(responceDict: result ?? [String:Any]())
                completion(closure)
                } catch let err as NSError {
                    print(err)
                }
            }
        }.resume()
    }
}
