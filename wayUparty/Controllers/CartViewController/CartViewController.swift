//
//  CartViewController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 24/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import Razorpay
import MessageUI
import MarqueeLabel
class CartViewController: UIViewController {
    let imageCache = NSCache<AnyObject, AnyObject>()
    @IBOutlet weak var cartImagrView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topspendLbl: MarqueeLabel!
    var topspendList:TopSpendingModel! = nil
   
    
   // @IBOutlet weak var browseBtnSafeAreaConstraint: NSLayoutConstraint!
    var paymentId : String  = ""
    var razorpayObj : RazorpayCheckout? = nil
    var getCartList:GetCartListModel!
    var razorPayOrderID = String()
    var razorpayTestKey:String = "rzp_test_WzliCeX4Wy3GHk"
    @IBOutlet weak var browseRestuarentsBrn: UIButton!
    
   // @IBOutlet var orderplaceBtn: UIButton!
    @IBOutlet weak var empty_CartImg: UIImageView!
    
    @IBOutlet weak var addSomethingLbl: UILabel!
    @IBOutlet weak var cartLbl: UILabel!
    
    var total = ""
    var totalPrice = Double()
    
   
    
    /*Coupons Model**/
      var getcoupnsmodel:GetcoupnsModal!
   
    
    
    
    override func viewDidLoad() {
     super.viewDidLoad()
        
           getcoupnsdetails()
            print("Value:\(coupnCode)")
            print("offers:\(coupnofferValue)")
            print("titlers:\(coupontitle)")
           // self.orderplaceBtn.isHidden = true
           
            addLeftBarbtnIcon(named: "logo_Icon")
       
            self.browseRestuarentsBrn.layer.cornerRadius = 20
            self.browseRestuarentsBrn.layer.borderWidth = 2.0
            self.browseRestuarentsBrn.layer.borderColor = UIColor.init(red: 186.0/255.0, green: 153.0/255.0, blue: 96.0/255.0, alpha: 1.0).cgColor
       
//        if UIScreen.main.bounds.size.height == 667.0{
//            browseBtnSafeAreaConstraint.constant = 60
//        }
//        if UIScreen.main.bounds.size.height == 736.0{
//            browseBtnSafeAreaConstraint.constant = 80
//        }
//        if UIScreen.main.bounds.size.height == 812.0{
//            browseBtnSafeAreaConstraint.constant = 80
//        }
       // setUpNavigationBarItems()
        
        tableView.register(UINib(nibName: "PlaceOrderCell", bundle: nil), forCellReuseIdentifier: "PlaceOrderCell")
        NotificationCenter.default.addObserver(self, selector: #selector(self.getCoupondetails(_:)), name: NSNotification.Name(rawValue: "CoupnDetails"), object: nil)
            
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    } 
    
   
    
    
    func setBackgroundImageToviewcontroller(){
        let backImgae = UIImageView()
        backImgae.image = UIImage(named: "BG_Screen.jpg")
        backImgae.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(backImgae)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        topspendingList()
        self.tabBarController?.tabBar.isHidden = false
        
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String
        if userUUID != nil{
            showSwiftLoader()
            let constants = Constants()
            GetCartListParser.GetcartList(useruuid: userUUID ?? String(), xUsername: "\(constants.xUsername)", xPassword: "\(constants.xPassword)"){(responce) in
                self.hideSwiftLoader()
            self.getCartList = responce.cartListModel.first
            if self.getCartList == nil{
            DispatchQueue.main.async{
             self.cartImagrView.isHidden = false
             self.browseRestuarentsBrn.isHidden = false
                self.empty_CartImg.isHidden = false
                self.cartLbl.isHidden = false
                self.addSomethingLbl.isHidden = false
            }}
            else{
            isAnimationFalse = true
            DispatchQueue.main.async{
                if self.getCartList.cartUUID.count == 0{
                    self.cartImagrView.isHidden = false
                    self.browseRestuarentsBrn.isHidden = false
                    self.empty_CartImg.isHidden = false
                    self.cartLbl.isHidden = false
                    self.addSomethingLbl.isHidden = false
                }else{
                    self.cartImagrView.isHidden = true
                    self.browseRestuarentsBrn.isHidden = true
                    self.empty_CartImg.isHidden = true
                    self.cartLbl.isHidden = true
                    self.addSomethingLbl.isHidden = true
                }
                self.tableView.reloadData()
                          }
                     }
               }
        }
      
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coupnCode = ""
    }
    
    @objc func getCoupondetails(_ notification: NSNotification) {
            print(notification.userInfo ?? "")
            if let dict = notification.userInfo as NSDictionary? {
                
                guard let couponcodes = dict["couponcode"] as? String else{return}
                guard let minimumorder = dict["minimumOrder"] as? String else{return}
                guard let discounttype = dict["discountType"] as? String else {return}
                guard let offerval = dict["Codevalue"] as? String else {return}
                guard let coupnname = dict["coupnName"] as? String else {return}
                guard let displayoff = dict["displayoffer"] as? String else {return}
                //Codevalue
                print("\(discounttype),\(offerval)")
                coupnCode = couponcodes
                minorder = minimumorder
                discounttypes = discounttype
                codevalues = offerval
                couponname = coupnname
                displayOffer = displayoff
                tableView.reloadData()
            }
     }
   
    func getcoupnsdetails() {
        GetcoupnsParser.GetAvaialblecoupnsAPI(){(response) in
            self.getcoupnsmodel = response.getAvailableCoupnsModel.first
            DispatchQueue.main.async {
                self.tableView.delegate = self
                self.tableView.dataSource = self
            }
            
            
        }
    }
    func loadingIndicator(){
        isAnimationFalse = false
        var loadingSupport = LoadingSupport()
        loadingSupport = self.storyboard?.instantiateViewController(withIdentifier: "LoadingSupport") as! LoadingSupport
        addChild(loadingSupport)
        self.view.addSubview(loadingSupport.view)
    }
    
//    func setUpNavigationBarItems(){
//        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "list"), style: .plain, target: self, action: #selector(leftBarButtonItemAction))
//        leftBarButtonItem.tintColor = UIColor.init(red: 186.0/255.0, green: 156.0/255.0, blue: 93.0/255.0, alpha: 1.0)
//        self.navigationItem.leftBarButtonItem = leftBarButtonItem
//    }
//
//    @objc func leftBarButtonItemAction(){
//         self.view.endEditing(true)
//           self.slideMenuViewController().showLeftMenu(true)
//       }
//
    
    
    @IBAction func browseRestaurentsClicked(_ sender: UIButton) {
        tabBarScreen = "home"
        self.tabBarController?.selectedIndex = 0
    }
    
    func imageFromServerURL(URLString: String, placeHolder: UIImage?,imageView:UIImageView) {
     let imageViews = imageView
     imageViews.image = nil
        //If imageurl's imagename has space then this line going to work for this
        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let cachedImage = imageCache.object(forKey: NSString(string: imageServerUrl)) {
          imageViews.image = cachedImage as? UIImage
            return
        }

        if let url = URL(string: imageServerUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        imageViews.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                         self.imageCache.setObject(downloadedImage, forKey: NSString(string: imageServerUrl))
                            imageViews.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
    
    @IBAction func chatAct(_ sender: Any) {
        //Freshchat.sharedInstance().showConversations(self)
    }
    
}

class CartItemsCell:UITableViewCell{
    @IBOutlet weak var cartItemImageView: UIImageView!

    @IBOutlet weak var cartItemTitle: UILabel!

    @IBOutlet weak var cartItemAmount: UILabel!
    @IBOutlet weak var cartItemDate: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var cartItemTimeSlot: UILabel!
    

    var getCartList:GetCartListModel!
    var amountotal = Double()
  /*Coupons Model**/
    var getcoupnsmodel:GetcoupnsModal!
    var discType = ""
    var offType = ""
    var totalPay = Double()
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.getcoupon.layer.cornerRadius = 15
//        self.entercouponcodeTF.layer.borderColor = UIColor.white.cgColor
//        self.entercouponcodeTF.layer.borderWidth = 1
//        self.entercouponcodeTF.text = "Eneter Coupon Code"
//
//        self.offerVw.layer.cornerRadius = 10
//        lowerTranspImg.layer.cornerRadius = 15
//        placeOrderBtn.layer.cornerRadius = 15
//        contentVw.layer.cornerRadius = 15
//        adjustHeight.constant = 0
//        offerVw.isHidden = true
//        appliedLbl.isHidden = true
//        appliedvalue.isHidden = true
//
//        self.closebtn.addTarget(self, action: #selector(clearofferdetails(_sender:)), for: .touchUpInside)
//        self.applyBtn.addTarget(self, action: #selector(applyCouponcode), for: .touchUpInside)
        //self.getCartdetails()
        DispatchQueue.main.async {
           // self.getcoupnsdetails()
        }

//        let semaphore = DispatchSemaphore(value: 1)
//        let queue = DispatchQueue.global()
//       queue.async {
//           semaphore.wait() // 0
//            self.getCartdetails()
//            semaphore.signal()
//        }
//         queue.async {
//           semaphore.wait()
//            self.getcoupnsdetails()
//            semaphore.signal()
//        }
       
    }
    func getCartdetails()  {
        let constants = Constants()
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String
        GetCartListParser.GetcartList(useruuid: userUUID ?? String(), xUsername: "\(constants.xUsername)", xPassword: "\(constants.xPassword)"){(responce) in
            isAnimationFalse = true
            self.getCartList = responce.cartListModel.first
            DispatchQueue.main.async {
                let amount = self.getCartList.totalAmount
                for i in 0..<amount.count{
                    let totalamount = amount[i]
                    //self.totalPriceLbl.text = "Total:\(totalamount)"
                   // self.placeOrderBtn.tag = Int(totalamount)
                }
            }
            
            
        }
        

    }
    func getcoupnsdetails() {
        GetcoupnsParser.GetAvaialblecoupnsAPI(){(response) in
            self.getcoupnsmodel = response.getAvailableCoupnsModel.first
            
            
        }
    }
    func showToastat(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: contentView.frame.size.width/2 - 150, y: 350, width: 300, height: 50))
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
    

   
}

extension CartViewController:UITableViewDelegate,UITableViewDataSource{
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            if section == 0{
                if getCartList != nil{
                    return getCartList.cartUUID.count
                    
                }else{
                    return 0
                }
            }else{
               
               return 1
            }
        
       
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemsCell") as! CartItemsCell
            cell.removeBtn.tag = indexPath.row
       
        cell.removeBtn.addTarget(self, action: #selector(removeItemFromCart), for: .touchUpInside)
        
        cell.removeBtn.layer.cornerRadius = 15
        cell.cartItemImageView.layer.cornerRadius = 60
        cell.cartItemImageView.layer.borderColor = UIColor.white.cgColor
        cell.cartItemImageView.layer.borderWidth = 1
            
            let constants = Constants()
            self.imageFromServerURL(URLString:"\(constants.baseUrl)\(self.getCartList.serviceImage[indexPath.row])" , placeHolder: UIImage.init(named: "noImage.png"), imageView: cell.cartItemImageView)
            cell.cartItemTitle.text = self.getCartList.serviceName[indexPath.row]

            cell.discType = discounttypes
            cell.offType = codevalues
            cell.getCartdetails()
        
            
            cell.cartItemAmount.text = "RS: \(self.getCartList.totalAmount[indexPath.row])"
           
            cell.cartItemDate.text = self.getCartList.serviceOrderDate[indexPath.row]
            cell.cartItemTimeSlot.text = self.getCartList.timeSlot[indexPath.row]
           // cell.uppertranspImg.layer.cornerRadius = 15
            
         
            

            return cell
        }else{
            let paymentcell = tableView.dequeueReusableCell(withIdentifier: "PlaceOrderCell") as! PlaceOrderCell
            paymentcell.offertitleLbl.text = coupontitle
            paymentcell.offerValuelbl.text = coupnofferValue
            paymentcell.appliedvalue.text = offervalue
            if self.getCartList != nil{
                let total = self.getCartList.totalAmount.reduce(0, +)
                paymentcell.orderPriceLbl.text = "\(total)"
                paymentcell.discountLbl.text = "\(0.0)"
                paymentcell.totalPriceLbl.text = "RS:\(total)"
                paymentcell.placeOrderBtn.tag = Int(total)
                paymentcell.applyBtn.tag = Int(total)
                paymentcell.closebtn.tag = Int(total)
                self.totalPrice = Double(total)
            }
            
           // paymentcell.orderPriceLbl.text = "Rs:\(self.getCartList.totalAmount[indexPath.row])"
            
            paymentcell.getcoupon.addTarget(self, action: #selector(applyCoupnsView), for: .touchUpInside)
            paymentcell.placeOrderBtn.addTarget(self, action: #selector(placeOrder(_sender:)), for: .touchUpInside)
           
            if coupnCode != "" {
                paymentcell.entercouponcodeTF.text = coupnCode
                paymentcell.entercouponcodeTF.textColor = UIColor.white
                }else{
                print("fail")
                    paymentcell.entercouponcodeTF.text = "Eneter Coupon Code"
                    paymentcell.entercouponcodeTF.textColor = UIColor.gray
            }
    //}
            return paymentcell
        }
           
        
        
        
        
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 191
        }else{
            return UITableView.automaticDimension
        }
    }
    func completVc()  {
        
        showSwiftLoader()
        let story = UIStoryboard(name: "Main", bundle: nil)
        let payementSucces = story.instantiateViewController(withIdentifier: "PaymentSuccess") as! PaymentSuccess
        self.navigationController?.pushViewController(payementSucces, animated: true)
        
        
    }
    
    @objc func placeOrder(_sender:UIButton){
        self.totalPrice = Double(_sender.tag)
         print("amount:\(totalPrice)")

        showSwiftLoader()
        let constants = Constants()

         let paymentInfo = ["cartAmount":"\(self.totalPrice)","currency":"INR"]
        GenerateOrderIDParser.RazorpayGenerateOrderAPI(xUsername: constants.xUsername,xPassword: constants.xPassword,patymentInfo: paymentInfo){(responce) in
            self.hideSwiftLoader()
            let orderId = responce.getOrderIdModel?.first?.orderId ?? String()
            self.razorPayOrderID = orderId
            print("a3\(self.razorPayOrderID)")
          
                DispatchQueue.main.async {
                    self.hideSwiftLoader()
                    //self.showPaymentForm(orderId: orderId)
                    let story = UIStoryboard(name: "Main", bundle: nil)
                    let placeorder = story.instantiateViewController(withIdentifier: "PlaceOrderScreen") as! PlaceOrderScreen
                    placeorder.order_id = orderId
                    placeorder.getCartList = self.getCartList
                    placeorder.totalPrice = self.totalPrice
                    self.navigationController?.pushViewController(placeorder, animated: false)
                    
                    
                }
            
            
        }
      
    }
   
    @objc func applyCoupnsView(){
        let story = UIStoryboard(name: "Main", bundle: nil)
        let coupnsView = story.instantiateViewController(withIdentifier: "CouponsController") as! CouponsController
          coupnCode = "Enter Coupon Code"
        coupnsView.modalPresentationStyle = .overFullScreen
       self.present(coupnsView, animated: false)
        
        
        
    }
    
    @objc func removeItemFromCart(_sender:UIButton){
       showSwiftLoader()
        let constants = Constants()
    RemoveCartItemParser.RemoveItemFromCartWith(xUsername: "\(constants.xUsername)", xPassword: "\(constants.xPassword)", cartUUID: self.getCartList.cartUUID[_sender.tag]){(removed) in
        self.hideSwiftLoader()
            let message = removed.addToCartModel.first?.responce ?? String()
            if message == "SUCCESS"{
                DispatchQueue.main.async {
                    self.viewWillAppear(true)
                    
                }
            }
        }
    }
}


//extension CartViewController : RazorpayPaymentCompletionProtocol{
//    func onPaymentError(_ code: Int32, description str: String) {
//        print(str)
//        print(code)
//    }
//
//    func onPaymentSuccess(_ payment_id: String) {
//        showSwiftLoader()
//        print(self.getCartList.cartUUID)
//        var str = String()
//        str = self.getCartList.cartUUID.joined(separator: ",")
//        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String
//        print(userUUID ?? "No user Id available")
//        let cartData = ["userUUID":userUUID,"cartItems":str,"paymentId":payment_id,"orderId":"\(self.razorPayOrderID)","signature":""]
//        let constants = Constants()
//        PlaceOrderParser.PlaceOrderWithCartUUIDs(xUsername: "\(constants.xUsername)", xPassword: "\(constants.xPassword)", cartData: cartData as [String : Any]){(responce) in
//            let result = responce.addToCartModel.first?.responce
//            if result == "SUCCESS"{
//                self.hideSwiftLoader()
//                DispatchQueue.main.async {
//                    self.completVc()
//                }
//            }
//
//        }
//    }
//
//    internal func showPaymentForm(orderId:String){
//        showSwiftLoader()
//
//        razorpayTestKey = self.getCartList.razorpayKeyId
//        print(razorpayTestKey)
//
//        let total = self.getCartList.totalAmount.reduce(0, +)
//        let paisaTotal = self.totalPrice * 100
//        print("tt:\(paisaTotal)")
//        razorpayObj = RazorpayCheckout.initWithKey(razorpayTestKey, andDelegate: self)
//        let userEmail = UserDefaults.standard.object(forKey: "userEmail") as? String ?? ""
//        let userMobile = UserDefaults.standard.object(forKey: "userMobile") as? String ?? ""
//        let options: [String:Any] = [
//                    "amount": "\(paisaTotal)",
//                    "currency": "INR",
//                    "description": "Party Your Way",
//                    "orderId":"\(orderId)",
//                    "image": "http://aws.wayuparty.com/resources/img/logo.png",
//                    "name": "wayUparty",
//                    "prefill": [
//                        "contact": "\(userMobile)",
//                        "email": "\(userEmail)"
//                    ],
//                    "theme": [
//                        "color": "#cfb376"
//                      ]
//                ]
//
//        self.tabBarController?.tabBar.isHidden = true
//        razorpayObj?.open(options, displayController: self)
//    }
//
//}
//



extension CartViewController{
    func topspendingList()  {
        self.topspendLbl.isHidden = true
        TopSpendParser.getFilterList{(response) in
            print("spendingList:--->\(response)")
            self.topspendList = response.topspendList.first
//            let arraList = self.topspendList.cityName
//            let str = arraList.joined(separator: ", ")
            DispatchQueue.main.async {
                self.topspendLbl.type = .continuous
                self.topspendLbl.speed = .rate(25)
                self.topspendLbl.fadeLength = 10.0
                self.topspendLbl.leadingBuffer = 10.0
                self.topspendLbl.trailingBuffer = 10.0
               // self.topspendLbl.text = str
            }
            
        }
        
    }
}
