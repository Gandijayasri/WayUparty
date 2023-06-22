//
//  MenWomenRatioController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 05/12/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import Stepperier
class MenWomenRatioController:BottomPopupViewController {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var popUpTitleStr : String?
    var mRatio:Int = 0
    var wRatio:Int = 0
    
   
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override var popupHeight: CGFloat {return height ?? CGFloat(300)}
    
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
    
    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    override var popupDimmingViewAlpha: CGFloat { return BottomPopupConstants.kDimmingViewDefaultAlphaValue }
}

class MenRatioCell:UITableViewCell{
    @IBOutlet weak var menStepper: Stepperier!
    @IBOutlet weak var menSupportView: UIView!
}

class PopUpControllerTitleCell:UITableViewCell{
   @IBOutlet weak var popUpTitle: UILabel!
}

class WomenRatioCell:UITableViewCell{
    @IBOutlet weak var womenStepper: Stepperier!
    @IBOutlet weak var womenSupportView: UIView!
}

class ConfirmMenWomenRatioCell:UITableViewCell{
    @IBOutlet weak var confirmBtn:UIButton!
}

extension MenWomenRatioController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopUpControllerTitleCell") as! PopUpControllerTitleCell
            cell.popUpTitle.text = self.popUpTitleStr
            return cell
        }
        if indexPath.row == 1{let cell = tableView.dequeueReusableCell(withIdentifier: "MenRatioCell") as! MenRatioCell
            cell.menStepper.value = menRatio
            cell.menStepper.addTarget(self, action: #selector(menStepperierValueDidChange), for: .valueChanged)
            cell.menSupportView.layer.cornerRadius = 17
            return cell
        }
        if indexPath.row == 2{let cell = tableView.dequeueReusableCell(withIdentifier: "WomenRatioCell") as! WomenRatioCell
            cell.womenStepper.value = womenRatio
            cell.womenStepper.addTarget(self, action: #selector(womenStepperierValueDidChange), for: .valueChanged)
            cell.womenSupportView.layer.cornerRadius = 17
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmMenWomenRatioCell") as! ConfirmMenWomenRatioCell
            cell.confirmBtn.layer.cornerRadius = 22.5
            cell.confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    @objc func confirmBtnAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func menStepperierValueDidChange(_ stepper: Stepperier) {
            print("Updated value: \(stepper.value)")
            menRatio = Int(stepper.value)
            mRatio = Int(stepper.value)
            womenRatio = wRatio
            self.tableView.reloadData()
    }
    
    @objc func womenStepperierValueDidChange(_ stepper: Stepperier) {
            print("Updated value: \(stepper.value)")
            womenRatio = Int(stepper.value)
            wRatio = Int(stepper.value)
            womenRatio = wRatio
            self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 || indexPath.row == 2{return 76}
        if indexPath.row == 0{return 54}
        if indexPath.row == 3{return 70}
        else{return 0}
    }
    
}
