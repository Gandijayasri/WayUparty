//
//  RateOrderViewController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 14/02/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import UIKit
import AARatingBar
class RateOrderViewController: UIViewController {
    var userUUID:String =  ""
    var placeOrderCode:String = ""
    var ratingTag:String = ""
    var ratiingDecriptionTxtView = UITextView()
    @IBOutlet weak var tableView:UITableView!
    var ratingValue:CGFloat =  0.0
    var ratingDiscription:String  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Rate Order"
        ratiingDecriptionTxtView.textColor = UIColor.white
        ratiingDecriptionTxtView.tintColor = UIColor.white
        self.ratiingDecriptionTxtView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource  = self
        self.tableView.keyboardDismissMode  =  .onDrag
        
    }
   
    
    func loadingIndicator(){
        isAnimationFalse = false
        var loadingSupport = LoadingSupport()
        loadingSupport = self.storyboard?.instantiateViewController(withIdentifier: "LoadingSupport") as! LoadingSupport
        addChild(loadingSupport)
        self.view.addSubview(loadingSupport.view)
    }
    
    @IBAction func submitFeedBackActionEevnt(_ sender: UIButton) {
        self.loadingIndicator()
        
        if self.ratingValue == 0.0 || self.ratiingDecriptionTxtView.text == "" || self.ratiingDecriptionTxtView.text == "Please provide your description herePlease provide your description here"{
            let alert = UIAlertController(title: "Message", message: "Please provide your rating and description to submit feedback", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            isAnimationFalse = true
            self.present(alert, animated: true, completion: nil)
        }else{
            let constants = Constants()
            let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String ?? ""
            let userOrderRatingPayload =  ["userUUID":userUUID,"placeOrderCode":self.placeOrderCode,"rating":"\(Int(self.ratingValue))","ratingTag":self.ratingTag,"ratingDescription":self.ratiingDecriptionTxtView.text ??  String()] as [String : Any]
            SaveUserOrderRatingParser.SaveUserOrderRatingAPI(xUsername: constants.xUsername, xPassword: constants.xPassword, userOrderRatingData: userOrderRatingPayload){(responce) in
                if "\(responce.addToCartModel.first?.responce ?? "No Value")" == "SUCCESS"{
                    isAnimationFalse = true
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}

class RateOrderCell:UITableViewCell{
    @IBOutlet weak var ratingBar:AARatingBar!
    @IBOutlet weak var ratingLbl:UILabel!
}

class  RateOrderDescriptionCell:UITableViewCell{
    @IBOutlet weak var ratiingDecriptionTxtView:UITextView!
    override func awakeFromNib() {
        ratiingDecriptionTxtView.layer.borderWidth = 0.5
        ratiingDecriptionTxtView.layer.borderColor = UIColor.lightGray.cgColor
        ratiingDecriptionTxtView.text = "Please provide your description here"
        ratiingDecriptionTxtView.textColor = UIColor.lightGray
    }
    
}

extension RateOrderViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell  = tableView.dequeueReusableCell(withIdentifier: "RateOrderCell") as! RateOrderCell
            cell.ratingLbl.text = "Rate Your Order !"
            cell.ratingBar.starFont = UIFont.boldSystemFont(ofSize:25)
            cell.ratingBar.ratingDidChange = { ratingValue in
                self.ratingValue = ratingValue
                switch ratingValue {
                case 1.0:
                cell.ratingLbl.text = "Very Bad"
                case 2.0:
                cell.ratingLbl.text = "Bad"
                case 3.0:
                cell.ratingLbl.text = "Average"
                case 4.0:
                cell.ratingLbl.text = "Good"
                case 5.0:
                cell.ratingLbl.text = "Loved It !"
                default:
                    print("no default")
                }
                self.ratingTag = cell.ratingLbl.text ?? ""
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RateOrderDescriptionCell") as! RateOrderDescriptionCell
            cell.ratiingDecriptionTxtView.delegate  = self
            self.ratiingDecriptionTxtView = cell.ratiingDecriptionTxtView
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 182
        case 1:
            return 279
        default:
            return 0
        }
    }
}

extension RateOrderViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please provide your description here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
