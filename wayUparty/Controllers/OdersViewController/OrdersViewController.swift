//
//  ViewController.swift
//  Orders
//
//  Created by Jasty Saran  on 05/11/20.
//

import UIKit
import MessageUI
import MarqueeLabel

class OrdersViewController: UIViewController {
    @IBOutlet weak var browseRestaurentBtn: UIButton!
    @IBOutlet weak var hiddableView:UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topspendLbl: MarqueeLabel!
    
    var ordersList:GetOrderListModel! = nil
    var topspendList:TopSpendingModel! = nil
    var heightArrays = Array<CGFloat>()
    var isOrderRated:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // self.setUpNavigationBarItems()
        
     
        addLeftBarbtnIcon(named: "logo_Icon")
        
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String ?? ""
        // Do any additional setup after loading the view.
        if userUUID == ""{
            self.hiddableView.isHidden = false
            
        }
        else{showSwiftLoader()
            self.hiddableView.isHidden = true
            
        }
        browseRestaurentBtn.layer.cornerRadius = 20
        browseRestaurentBtn.layer.borderWidth = 2
        browseRestaurentBtn.layer.borderColor = UIColor.init(red: 186.0/255.0, green: 153.0/255.0, blue: 96.0/255.0, alpha: 1.0).cgColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }
   
    
    @IBAction func browseRestuarentClicked(_ sender: Any) {
           tabBarScreen = "home"
           self.tabBarController?.selectedIndex = 0
       }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden =  false
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String ?? ""
        topspendingList()
       
        if userUUID == ""{
            self.hiddableView.isHidden = false
        }
        else{showSwiftLoader()
            self.hiddableView.isHidden = true
            GetOrdersLisrParser.getOrdersList(userUUID: userUUID){(responce) in
                if responce.getOrderListModel.first?.clubName.count == nil || responce.getOrderListModel.first?.clubName.count == 0{
                    self.hideSwiftLoader()
                    DispatchQueue.main.async {
                        self.hiddableView.isHidden = false
                    }
                }
                else{
                    self.hideSwiftLoader()
                    self.ordersList = responce.getOrderListModel.first
                    DispatchQueue.main.async {
                        self.hiddableView.isHidden = true
                        for i in 0..<self.ordersList.orderItems.count{
                            let height = self.heightForView(text: "\(self.ordersList.orderItems[i])", font: UIFont.systemFont(ofSize: 12), width: UIScreen.main.bounds.size.width - 55)
                            self.heightArrays.append(height)
                            print(self.heightArrays)
                        }
                        self.tableView.reloadData()
                    }
                }
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
    
//    @objc func leftBarButtonItemAction(){
//        self.view.endEditing(true)
//        self.slideMenuViewController().showLeftMenu(true)
//    }


    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 20, y: 7, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    @IBAction func chatAct(_ sender: Any) {
       // Freshchat.sharedInstance().showConversations(self)
    }
}

extension OrdersViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.ordersList != nil{
            switch indexPath.row {
            case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStatusCell") as! OrderStatusCell
            cell.resturentCity.text = self.ordersList.clubLocation[indexPath.section]
            cell.resturentNameLbl.text = self.ordersList.clubName[indexPath.section]
            cell.orderTotalPrice.text = "₹ \(self.ordersList.totalAmount[indexPath.section])"
            cell.dateLbl.text = self.ordersList.orderDate[indexPath.section]
            let cancelledOrderCount = self.ordersList.canceledOrdersCount[indexPath.section]
            if cancelledOrderCount != 0{
                    cell.statusTxt.text = "\(cancelledOrderCount) items Cancelled"
                    cell.statusTxt.backgroundColor = UIColor.init(red: 168.0/255.0, green: 63.0/255.0, blue: 63.0/255.0, alpha: 1.0)
                    cell.statusTxt.textColor = UIColor.white
                    cell.statusTxt.isHidden = false
            }else{
                    cell.statusTxt.isHidden = true
            }
            return cell
            case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemsCell") as! OrderItemsCell
            cell.orderItemsCell.text = self.ordersList.orderItems[indexPath.section]
            cell.orderItemsCell.frame = CGRect.init(x: 20, y: 7, width: UIScreen.main.bounds.size.width - 45, height: self.heightArrays[indexPath.section])
                
            return cell
            case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReorderCell") as! ReorderCell
                self.isOrderRated = self.ordersList.isUserRated[indexPath.section]
               
                print(self.isOrderRated)
                if self.isOrderRated == "Y"{cell.rateOrderBtn.isHidden  =  true
                    cell.headerLbl.isHidden  =  false
                    cell.starImageView.isHidden  =  false
                    cell.ratingLbl.isHidden  =  false
                    cell.ratingTagLbl.isHidden  =  false
                    cell.ratingLbl.text = "\(self.ordersList.rating[indexPath.section]) -"
                    switch self.ordersList.rating[indexPath.section] {
                    case 1:
                    cell.ratingTagLbl.text =  "Very Bad"
                    case 2:
                    cell.ratingTagLbl.text =  "Bad"
                    case 3:
                    cell.ratingTagLbl.text =  "Average"
                    case 4:
                    cell.ratingTagLbl.text =  "Good"
                    case 5:
                    cell.ratingTagLbl.text =  "Loved It"
                    default:
                    print("no default")
                    }
                }
                else{cell.rateOrderBtn.isHidden  =  false
                    cell.headerLbl.isHidden  =  true
                    cell.starImageView.isHidden  =  true
                    cell.ratingLbl.isHidden  =  true
                    cell.ratingTagLbl.isHidden  =  true
                }
                cell.rateOrderBtn.tag = indexPath.section
                cell.rateOrderBtn.addTarget(self, action: #selector(rateBtnAction), for: .touchUpInside)
               
            return cell
            default:
                return UITableViewCell()
            }
        }else{
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.ordersList != nil{return self.ordersList.orderItems.count}
        else{return 0}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.ordersList != nil{return 3}
        else{return 0}
    }
    
    @objc func rateBtnAction(_sender:UIButton){
        var rateOrderCon = RateOrderViewController()
        rateOrderCon = self.storyboard?.instantiateViewController(withIdentifier: "RateOrderViewController") as! RateOrderViewController
        rateOrderCon.placeOrderCode = self.ordersList.placeOrderCode[_sender.tag]
        self.navigationController?.pushViewController(rateOrderCon, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:return 100
        case 1:
            let height = self.heightArrays[indexPath.section]
            if height > 30.0{
                return self.heightArrays[indexPath.section]
            }else{
                return 37
            }
        case 2:return 70
        default:return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var qrCodeCon = QRCodeController()
        qrCodeCon = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeController") as! QRCodeController
        qrCodeCon.orderItemsParsable = self.ordersList.orderItems[indexPath.section]
        qrCodeCon.orderItemPricesParsable = self.ordersList.orderRates[indexPath.section]
        qrCodeCon.totalPrice = "\(self.ordersList.totalAmount[indexPath.section])"
        qrCodeCon.qrImgUrl = self.ordersList.qrCode[indexPath.section]
        qrCodeCon.orderStatus = self.ordersList.orderStatus[indexPath.section]
        qrCodeCon.cancelStatus = self.ordersList.orderItemsCanceled[indexPath.section]
        qrCodeCon.rescheduleStatus = self.ordersList.orderItemsReschedule[indexPath.section]
        qrCodeCon.orderItemUUIDs = self.ordersList.orderUUIDs[indexPath.section]
        self.navigationController?.pushViewController(qrCodeCon, animated: true)
    }
}

class OrderStatusCell:UITableViewCell{
    
    @IBOutlet weak var dottedView: UIView!
    @IBOutlet weak var statusTxt: UILabel!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var resturentNameLbl: UILabel!
    @IBOutlet weak var orderTotalPrice: UILabel!
    @IBOutlet weak var resturentCity: UILabel!
    @IBOutlet weak var rateOrderBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
}

class OrderItemsCell:UITableViewCell{
    
    @IBOutlet weak var orderItemsCell: UILabel!
}

class OrderDateCell:UITableViewCell{
    
    @IBOutlet weak var dateLbl: UILabel!
}

class ReorderCell:UITableViewCell{
    @IBOutlet weak var reorderBtn:UIButton!
    @IBOutlet weak var rateOrderBtn:UIButton!
    @IBOutlet weak var headerLbl:UILabel!
    @IBOutlet weak var starImageView:UIImageView!
    @IBOutlet weak var ratingLbl:UILabel!
    @IBOutlet weak var seperatorImage:UIImageView!
    @IBOutlet weak var ratingTagLbl:UILabel!
    override func awakeFromNib() {
        self.rateOrderBtn.layer.cornerRadius = 10.0
        self.rateOrderBtn.layer.borderColor = UIColor.black.cgColor
        self.rateOrderBtn.layer.borderWidth = 1.0
    }
}



class CustomView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(2)
            context.move(to: CGPoint(x: 0, y: bounds.height))
            context.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
            context.strokePath()
        }
    }
}

extension OrdersViewController{
    func topspendingList()  {
        self.topspendLbl.isHidden = true
        TopSpendParser.getFilterList{(response) in
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
