//
//  GetcoupnsCompletion.swift
//  wayUparty
//
//  Created by Arun on 06/04/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import Foundation

class GetcoupnsCompletionBlock{
    let getAvailableCoupnsModel:[GetcoupnsModal]!
    init(responseDict:[String:Any])throws {
        var getavaialbleCoupnsModel = [GetcoupnsModal]()
        let model = GetcoupnsModal.init(responceDict: responseDict)
        if model != nil{getavaialbleCoupnsModel.append(model!)}
        self.getAvailableCoupnsModel = getavaialbleCoupnsModel
        
        
    }
    
}
