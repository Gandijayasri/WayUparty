//
//  RescheduleController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 17/12/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit

class RescheduleController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    var datesArray = Array<String>()
    var timeSlotsArray = Array<String>()
    var checkDatesArray = Array<Bool>()
    var checkTimeSlotsArray = Array<Bool>()
    var xeroxDateArray = Array<String>()
    var xeroxTimeSlotsArray = Array<String>()
    var orderItemUUID = String()
    var passableDates = Array<String>()
    var navCon = UINavigationController()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        let constants = Constants()
        RescheduleModelParser.RescheduleOrderAPI(xUsername: constants.xUsername, xPassword: constants.xPassword, orderItemUUID: self.orderItemUUID){(responce) in
                let servicedates = responce.rescheduleModel.first?.serviceDates.value(forKey: "serviceDate") as? NSArray
                let passableDates = responce.rescheduleModel.first?.serviceDates.value(forKey: "passableDate") as? NSArray
                let timeslotsList = responce.rescheduleModel.first?.timeSlotList.value(forKey: "timeSlot") as? NSArray
                self.datesArray = servicedates as? Array<String> ?? []
                self.passableDates = passableDates as? Array<String> ?? []
                self.timeSlotsArray = timeslotsList as? Array<String> ?? []
                print(self.datesArray)
                print(self.passableDates)
                print(self.timeSlotsArray)
                self.xeroxDateArray = self.datesArray
                self.xeroxTimeSlotsArray = self.timeSlotsArray
                self.datesArray = []
                self.timeSlotsArray = []
//                self.radioBtnChecker()
//                self.radioBtrChecker()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func rescheduleOrderAction(_ sender: UIButton) {
        var serviceDate = String()
        var timeSlot = String()
        for i in 0..<self.checkDatesArray.count{
            let boolCheck = self.checkDatesArray[i]
            if boolCheck == true{
                serviceDate = self.passableDates[i]
            }
        }
        for i in 0..<self.checkTimeSlotsArray.count{
            let boolCheck = self.checkTimeSlotsArray[i]
            if boolCheck == true{
                timeSlot = self.xeroxTimeSlotsArray[i]
            }
        }
        let constants = Constants()
        let rescheduleOrderData = ["orderUUID":self.orderItemUUID,"serviceOrderDate":serviceDate,"serviceTimeSlot":timeSlot]
        RescheduleOrderParser.RescheduleOrderParser(xUseraname: constants.xUsername, xPassword: constants.xPassword, orderData: rescheduleOrderData){(responce) in
            if (responce.addToCartModel.first?.responce ?? "Something went wrong") == "SUCCESS" {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Message", message: "Your order has been rescheduled to \(serviceDate) at \(timeSlot)", preferredStyle: .alert)
                  // Create the actions
                let okAction = UIKit.UIAlertAction(title: "OK", style: UIKit.UIAlertAction.Style.default) {
                      UIAlertAction in
                    self.dismiss(animated: true){
                        self.navCon.popToRootViewController(animated: true)
                    }
                  }
                  // Add the actions
                  alertController.addAction(okAction)
                  self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

//extension RescheduleController:UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0{
//            if indexPath.row == 0{
//             let cell = tableView.dequeueReusableCell(withIdentifier: "PickaDateCell") as! PickaDateCell
//             return cell
//            }
//            else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: "DateResultsCell") as! DateResultsCell
//                cell.resultLbl.text = self.datesArray[indexPath.row - 1]
//                cell.radioBtn.tag = indexPath.row - 1
//                let check = checkDatesArray[indexPath.row - 1]
//                if check == true{
//                    cell.radioBtn.isSelected = true
//                    cell.radioBtn.setImage(UIImage(named: "check"), for: .normal)
//                }
//                if check == false{ cell.radioBtn.isSelected = false
//                    cell.radioBtn.setImage(UIImage(named: "Radio.png"), for: .normal)
//                }
//                cell.radioBtn.addTarget(self, action: #selector(radionBtnAction), for: .touchUpInside)
//                return cell
//            }
//        }
//        if indexPath.section == 1{
//            if indexPath.row == 0{
//                let cell = tableView.dequeueReusableCell(withIdentifier: "PickaTimeSlotCell") as! PickaTimeSlotCell
//                return cell
//            }else{
//             let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSlotsResultsCell") as! TimeSlotsResultsCell
//                cell.resultLbl.text = self.timeSlotsArray[indexPath.row - 1]
//
//                cell.radioBrn.tag = indexPath.row - 1
//                let check = checkTimeSlotsArray[indexPath.row - 1]
//                if check == true{
//                    cell.radioBrn.isSelected = true
//                    cell.radioBrn.setImage(UIImage(named: "check"), for: .normal)
//                }
//                if check == false{ cell.radioBrn.isSelected = false
//                    cell.radioBrn.setImage(UIImage(named: "Radio.png"), for: .normal)
//                }
//                cell.radioBrn.addTarget(self, action: #selector(radionBtrAction), for: .touchUpInside)
//                return cell
//            }
//
//        }
//        return UITableViewCell()
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0{
//            if datesArray.count == 0{return 1}
//            else{return datesArray.count + 1}
//        }
//        if section == 1{
//            if timeSlotsArray.count == 0{return 1}
//            else{return timeSlotsArray.count + 1}
//        }
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0{return 69}
//        if indexPath.section == 1{return 69}
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0{
//            if indexPath.row == 0{
//                if datesArray.count == 0 {
//                 datesArray = xeroxDateArray
//                }else{
//                  datesArray = []
//                }
//            }
//
//        }
//        if indexPath.section == 1{
//        if indexPath.row == 0{
//                if timeSlotsArray.count == 0{
//                 timeSlotsArray = xeroxTimeSlotsArray
//                }
//                else{
//                    timeSlotsArray = []
//                  }
//            }
//        }
//        self.tableView.reloadData()
//    }
//
//    @objc func radionBtnAction(sender:UIButton){
//        self.radioBtnChecker()
//        if sender.isSelected == true{
//            sender.isSelected = false
//            sender.setImage(UIImage(named: "Radio.png"), for: .normal)
//            checkDatesArray[sender.tag] = false
//        }else{
//            sender.isSelected = true
//            sender.setImage(UIImage(named: "check"), for: .normal)
//            checkDatesArray[sender.tag] = true
//        }
//        print(checkDatesArray)
//        self.tableView.reloadData()
//    }
//
//    @objc func radionBtrAction(sender:UIButton){
//        self.radioBtrChecker()
//      if sender.isSelected == true{
//            sender.isSelected = false
//            checkTimeSlotsArray[sender.tag] = false
//        }else{
//            sender.isSelected = true
//            checkTimeSlotsArray[sender.tag] = true
//        }
//        print(checkTimeSlotsArray)
//        self.tableView.reloadData()
//    }
//    func radioBtnChecker(){
//        checkDatesArray.removeAll()
//        for _ in 0..<xeroxDateArray.count{
//            checkDatesArray.append(false)
//        }
//    }
//
//    func radioBtrChecker(){
//        checkTimeSlotsArray.removeAll()
//        for _ in 0..<xeroxTimeSlotsArray.count{
//            checkTimeSlotsArray.append(false)
//        }
//    }
//}
