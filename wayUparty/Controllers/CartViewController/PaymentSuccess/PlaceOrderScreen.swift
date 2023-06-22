//
//  PlaceOrderScreen.swift
//  wayUparty
//
//  Created by Arun  on 11/05/23.
//  Copyright © 2023 Arun. All rights reserved.
//

import UIKit
import Razorpay

class PlaceOrderScreen: UIViewController {
    
    // @IBOutlet weak var browseBtnSafeAreaConstraint: NSLayoutConstraint!
     var paymentId : String  = ""
     var razorpayObj : RazorpayCheckout? = nil
     var getCartList:GetCartListModel!
     var razorPayOrderID = String()
     var razorpayTestKey:String = "rzp_test_WzliCeX4Wy3GHk"
     var totalPrice = Double()
     var order_id = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSwiftLoader()
        self.showPaymentForm(orderId: order_id)
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension PlaceOrderScreen : RazorpayPaymentCompletionProtocol{
    func onPaymentError(_ code: Int32, description str: String) {
        print(str)
        print(code)
    }
   
    func onPaymentSuccess(_ payment_id: String) {
        showSwiftLoader()
        print(self.getCartList.cartUUID)
        var str = String()
        str = self.getCartList.cartUUID.joined(separator: ",")
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String
        print(userUUID ?? "No user Id available")
        let cartData = ["userUUID":userUUID,"cartItems":str,"paymentId":payment_id,"orderId":"\(self.razorPayOrderID)","signature":""]
        let constants = Constants()
        PlaceOrderParser.PlaceOrderWithCartUUIDs(xUsername: "\(constants.xUsername)", xPassword: "\(constants.xPassword)", cartData: cartData as [String : Any]){(responce) in
            let result = responce.addToCartModel.first?.responce
            if result == "SUCCESS"{
                self.hideSwiftLoader()
                DispatchQueue.main.async {
                    self.completVc()
                }
            }
            
        }
    }
    
    internal func showPaymentForm(orderId:String){
        showSwiftLoader()
        
        razorpayTestKey = self.getCartList.razorpayKeyId
        print(razorpayTestKey)

        let total = self.getCartList.totalAmount.reduce(0, +)
        let paisaTotal = self.totalPrice * 100
        print("tt:\(paisaTotal)")
        razorpayObj = RazorpayCheckout.initWithKey(razorpayTestKey, andDelegate: self)
        let userEmail = UserDefaults.standard.object(forKey: "userEmail") as? String ?? ""
        let userMobile = UserDefaults.standard.object(forKey: "userMobile") as? String ?? ""
        let options: [String:Any] = [
                    "amount": "\(paisaTotal)",
                    "currency": "INR",
                    "description": "Party Your Way",
                    "orderId":"\(orderId)",
                    "image": "http://aws.wayuparty.com/resources/img/logo.png",
                    "name": "wayUparty",
                    "prefill": [
                        "contact": "\(userMobile)",
                        "email": "\(userEmail)"
                    ],
                    "theme": [
                        "color": "#cfb376"
                      ]
                ]
        
        self.tabBarController?.tabBar.isHidden = true
        razorpayObj?.open(options, displayController: self)
    }
    func completVc()  {
        
        showSwiftLoader()
        let story = UIStoryboard(name: "Main", bundle: nil)
        let payementSucces = story.instantiateViewController(withIdentifier: "PaymentSuccess") as! PaymentSuccess
        self.navigationController?.pushViewController(payementSucces, animated: true)
        
        
    }
    
}

