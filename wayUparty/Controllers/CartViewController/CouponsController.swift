//
//  CouponsController.swift
//  wayUparty
//
//  Created by Arun on 06/04/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import UIKit

class CouponsController: UIViewController {

    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var coupnsTable: UITableView!
    var getcoupnsmodel:GetcoupnsModal! 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetcoupnsParser.GetAvaialblecoupnsAPI(){(response) in
            self.getcoupnsmodel = response.getAvailableCoupnsModel.first
            DispatchQueue.main.async {
                self.coupnsTable.delegate = self
                self.coupnsTable.dataSource = self
                self.coupnsTable.reloadData()
            }
        }
      setUIElements()
        
    }
    func setUIElements()  {
        cancelBtn.layer.cornerRadius = 15
        //cancelBtn.layer.borderWidth = 1
       // cancelBtn.layer.borderColor = UIColor.blue.cgColor
    }
    
    @IBAction func CancelAct(_ sender: UIButton) {
        self.dismiss(animated: true,completion: nil)
        
    }
    
   
}
class CoupnslistCell: UITableViewCell {
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var offerPrice: UILabel!
    @IBOutlet var offerType: UILabel!
    
    @IBOutlet var applyBtn: UIButton!
}
extension CouponsController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getcoupnsmodel.coupnName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = coupnsTable.dequeueReusableCell(withIdentifier: "CoupnslistCell") as! CoupnslistCell
        cell.titleLbl.text = getcoupnsmodel.coupnName[indexPath.row]
        cell.offerPrice.text = getcoupnsmodel.coupncode[indexPath.row]
        cell.offerType.text = getcoupnsmodel.displayoffer[indexPath.row]
        cell.applyBtn.tag = indexPath.row
        cell.applyBtn.addTarget(self, action: #selector(applyCoupnscode(_sender:)), for: .touchUpInside)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    @objc func applyCoupnscode(_sender:UIButton){
        let  couponcode = getcoupnsmodel.coupncode[_sender.tag]
        let coupnValue = getcoupnsmodel.displayoffer[_sender.tag]
        let coupontitles = getcoupnsmodel.coupnName[_sender.tag]
        let offer = coupnValue.split(separator: " ")
        let offerValues = "\(offer[0])"
        let discountType = getcoupnsmodel.discounttype[_sender.tag]
        let Codevalue = getcoupnsmodel.couponValue[_sender.tag]
        let minimum = getcoupnsmodel.minimumOrder[_sender.tag]
        let couponname = getcoupnsmodel.coupnName[_sender.tag]
        let displayoffer = getcoupnsmodel.displayoffer[_sender.tag]
        
        
        let dataDict:[String: String] = ["couponcode": couponcode,"coupnValue":coupnValue,"coupontitles":coupontitles,"offerValues":offerValues,"discountType":discountType,"Codevalue":Codevalue,"minimumOrder":minimum,"coupnName":couponname,"displayoffer":displayoffer]

          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CoupnDetails"), object: nil, userInfo: dataDict)
        self.dismiss(animated: false,completion: nil)
        
    }
    
}
