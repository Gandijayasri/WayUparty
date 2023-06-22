//
//  PlaceOrderCell.swift
//  wayUparty
//
//  Created by Arun  on 02/05/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit

class PlaceOrderCell: UITableViewCell {
    @IBOutlet var getcoupon: UIButton!
    
    @IBOutlet var entercouponcodeTF: UILabel!
    
    @IBOutlet var applyBtn: UIButton!
    /*OfferView**/
    @IBOutlet var offerVw: UIView!
    @IBOutlet var offertitleLbl: UILabel!
    @IBOutlet var offerValuelbl: UILabel!
    @IBOutlet var closebtn: UIButton!
    
    @IBOutlet var totalPriceLbl: UILabel!
    @IBOutlet var orderPriceLbl: UILabel!
    @IBOutlet var discountLbl: UILabel!
    @IBOutlet var placeOrderBtn: UIButton!
    @IBOutlet var appliedvalue: UILabel!
    @IBOutlet var appliedLbl: UILabel!

    @IBOutlet weak var adjustHeight: NSLayoutConstraint!
    
    @IBOutlet weak var appliedcoupnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var contenVwHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
                self.getcoupon.layer.cornerRadius = 15
                self.entercouponcodeTF.layer.borderColor = UIColor.white.cgColor
                self.entercouponcodeTF.layer.borderWidth = 1
                self.entercouponcodeTF.text = "Eneter Coupon Code"
        
                self.offerVw.layer.cornerRadius = 10
                placeOrderBtn.layer.cornerRadius = 15
                adjustHeight.constant = 0
                offerVw.isHidden = true
                appliedLbl.isHidden = true
                appliedvalue.isHidden = true
                appliedcoupnHeight.constant = 0
           

                self.closebtn.addTarget(self, action: #selector(clearofferdetails(_sender:)), for: .touchUpInside)
                self.applyBtn.addTarget(self, action: #selector(applyCouponcode(_sender:)), for: .touchUpInside)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if  self.entercouponcodeTF.text == "Eneter Coupon Code"{
            adjustHeight.constant = 0
            offerVw.isHidden = true
            appliedLbl.isHidden = true
            appliedvalue.isHidden = true
            appliedcoupnHeight.constant = 0
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showToastat(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: contentView.frame.size.width/2 - 150, y: 150, width: 300, height: 50))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
       
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 11.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.contentView.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    @objc func clearofferdetails(_sender:UIButton){
        UIView.animate(withDuration: 0.5) {
            self.offerVw.isHidden = true
            self.adjustHeight.constant = 0
            self.appliedvalue.isHidden = true
            self.appliedLbl.isHidden = true
            self.entercouponcodeTF.text = "Eneter Coupon Code"
            self.discountLbl.text = "0.00"
            let amount = Double(_sender.tag)
            self.totalPriceLbl.text = "RS:\(amount)"
            self.appliedcoupnHeight.constant = 0
            self.offertitleLbl.text = ""
            self.offerValuelbl.text = ""

            
        }
    }
    @objc func applyCouponcode(_sender:UIButton){
        
          let amount = Double(_sender.tag)
           let minimum = Double(minorder) ?? 0.0
        
            if entercouponcodeTF.text == "Eneter Coupon Code" {
                showToastat(message: "Enter Valid Coupon Code!")

            }else if amount < minimum {
                showToastat(message: "on oreder above \(minorder)")
            }
        else{
                    UIView.animate(withDuration: 0.5) {
                        self.offerVw.isHidden = false
                        self.adjustHeight.constant = 60
                        self.appliedvalue.isHidden = false
                        self.appliedLbl.isHidden = false
                        self.appliedcoupnHeight.constant = 25
                        self.contenVwHeight.constant = 408
                        let discounttype = discounttypes
                        print(discounttype)
                        self.offertitleLbl.text = couponname
                        self.offerValuelbl.text = displayOffer
                    if discounttype == "RUPEES"{
                                        
                        let amount = Double(_sender.tag)
                        let discountoffer = Double(codevalues) ?? 0
                        let totalPrice = amount - discountoffer
                        self.appliedvalue.text = "-\(codevalues)"
                        self.discountLbl.text = String(totalPrice)
                        self.totalPriceLbl.text = String(totalPrice)
                        self.placeOrderBtn.tag = Int(totalPrice)

                        }else if discounttype == "PERCENTAGE"{
                            self.appliedvalue.text = "-\(codevalues)%"
                            let amount = Double(_sender.tag)
                            print("tasty:\(amount)")
                            let pricebefore = Double(amount)
                            let discountoffer = codevalues
                            let disc = Double(discountoffer) ?? 0
                            print("disc:\(disc)")
                            let totalprice = (amount * disc)/100
                            let pricedisc = Double(totalprice)
                            self.discountLbl.text = "\((pricebefore - totalprice))"
                            self.totalPriceLbl.text = "\((pricebefore - totalprice))"
                            let totalAmout = pricebefore - pricedisc
                            print("nice:\(totalAmout)")
                            self.placeOrderBtn.tag = Int(totalAmout)

                                    }
                                    else{
                                        let amount = Double(_sender.tag)
                                        self.discountLbl.text = String(amount)
                                        self.totalPriceLbl.text = String(amount)
                                        self.placeOrderBtn.tag = Int(amount)
                                    }
                                

                            
        /*get data**/

                    }


            }


        }

    
}
