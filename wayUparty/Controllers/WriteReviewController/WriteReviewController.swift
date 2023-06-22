//
//  WriteReviewController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 11/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import AwaitToast
class WriteReviewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var userRatingArray = Array<String>()
    var radioBtnArray = Array<Bool>()
    var restuarentUUID =  String()
    var reviewTxtView = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Rating"
        userRatingArray = ["Worst","Fair","Average","Good","Best"]
        radioBtnArray = [false,false,false,false,false]
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @objc func radioBtnHandler(sender:UIButton){
        radioBtnArray = [false,false,false,false,false]
        if sender.isSelected == true{
            sender.isSelected = false
            radioBtnArray[sender.tag] = false
        }else{
            sender.isSelected = true
            radioBtnArray[sender.tag] = true
        }
        print(radioBtnArray)
        self.tableView.reloadData()
    }
}


class UserRatingCell:UITableViewCell{
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var radioBtn: UIButton!
}

class WriteReviewCell:UITableViewCell{
    @IBOutlet weak var reviewTxtView: UITextView!
}

class SubmitReviewCell:UITableViewCell{
    @IBOutlet weak var submitBtn: UIButton!
}

extension WriteReviewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserRatingCell") as! UserRatingCell
            cell.ratingLbl.text = userRatingArray[indexPath.row]
            cell.radioBtn.tag = indexPath.row
            cell.radioBtn.addTarget(self, action: #selector(radioBtnHandler), for: .touchUpInside)
            let check = radioBtnArray[indexPath.row]
            if check == true{
                cell.radioBtn.isSelected = true
                cell.radioBtn.setImage(UIImage(named: "check"), for: .normal)
            }
            if check == false{ cell.radioBtn.isSelected = false
                cell.radioBtn.setImage(UIImage(named: "Radio.png"), for: .normal)
            }
            return cell
        }
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WriteReviewCell") as! WriteReviewCell
            cell.reviewTxtView.delegate = self
            cell.reviewTxtView.textColor = UIColor.lightGray
            self.reviewTxtView = cell.reviewTxtView
//            cell.reviewTxtView.layer.borderColor = UIColor.lightGray.cgColor
            return cell
        }
        if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitReviewCell") as! SubmitReviewCell
            cell.submitBtn.addTarget(self, action: #selector(submitBtnClicked), for: .touchUpInside)
            cell.submitBtn.layer.cornerRadius = 25
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{return userRatingArray.count}
        else{return 1}
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{return 62}
        if indexPath.section == 1{return 172}
        if indexPath.section == 2{return 46}
        return 0
    }
    
    @objc func submitBtnClicked(_ sender:UIButton){
        self.saveUserRating()
    }
    
    func loadingIndicator(){
        isAnimationFalse = false
        var loadingSupport = LoadingSupport()
        loadingSupport = self.storyboard?.instantiateViewController(withIdentifier: "LoadingSupport") as! LoadingSupport
        addChild(loadingSupport)
        self.view.addSubview(loadingSupport.view)
    }
    
    @objc func saveUserRating(){
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String
        let constants = Constants()
        var rating = ""
        for i in 0..<radioBtnArray.count{let checker = radioBtnArray[i];if checker == true{rating = userRatingArray[i]}}
        if rating == "Worst"{rating = "1"};if rating == "Fair"{rating = "2"};if rating == "Average"{rating = "3"};if rating == "Good"{rating = "4"};if rating == "Best"{rating = "5"}
        self.loadingIndicator()
        let userReviewData = ["userUUID":userUUID ?? "","vendorUUID":self.restuarentUUID,"rating":rating,"ratingDescription":self.reviewTxtView.text ?? String()] as [String : Any]
        print(userReviewData)
        SaveUserRatingAPI.SaveUserRatingAPI(xUsername: constants.xUsername, xPassword: constants.xPassword, userRatingData: userReviewData as [String : Any]){(responce) in
            if responce.addToCartModel.first?.responce == "SUCCESS"{
                isAnimationFalse = true
                DispatchQueue.main.async {
                    let toast = Toast.default(text: "Review Submitted Successfully", direction: .top)
                    toast.show()
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                isAnimationFalse = true
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Message", message: "\(responce.addToCartModel.first?.responce ?? "Please write review and rate the restuarent")", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

extension WriteReviewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
//        self.view.frame.origin.y -= 88+44*3 - 40
//        print(88+44 - self.view.frame.origin.y)
//        self.navigationController?.navigationBar.isHidden = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ""
            textView.textColor = UIColor.lightGray
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.view.frame.origin.y = 0
            self.navigationController?.navigationBar.isHidden = false
            return false
        }
        
        return true
    }
}
