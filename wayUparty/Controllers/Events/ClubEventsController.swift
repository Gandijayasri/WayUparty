//
//  ClubEventsController.swift
//  wayUparty
//
//  Created by Arun on 11/11/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import Razorpay

class ClubEventsController: UIViewController {
    var vendorUUID : String = ""
    var eventsArr:NSArray!
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    @IBOutlet weak var eventlist: UITableView!
    
    @IBOutlet var bookCardVw: UIView!
    
    @IBOutlet var imgVw: UIImageView!
    
    @IBOutlet var bookBtn: UIButton!
    
    //params
    var event_uuid = ""
    var user_uuid = ""
    var event_name = ""
    var event_loca = ""
    
    var event_img = ""
    var entrytype = ""
    var currency = 0
    var maxAllowed = 0
    
    
    
    //EntryView
    
    @IBOutlet var entryView: UIView!
    var entryArr:NSArray?
    
    //Select EntryView
    @IBOutlet var selectEntry: UIView!
    @IBOutlet var selectEntryLbl: UILabel!
    @IBOutlet var selectEntryList: UITableView!
    
    //Bookingcount
    
    @IBOutlet var bookingVw: UIView!
    @IBOutlet var bookinglistTable: UITableView!
    @IBOutlet var bookvwTitle: UILabel!
    var selectedMembers = 0
    
    //MapeView
    
    @IBOutlet var locationView: UIView!
    
    @IBOutlet var clubNameLbl: UILabel!
    
    @IBOutlet var addrLbl: UILabel!
    
    @IBOutlet var addresLbl: UILabel!
    
    @IBOutlet var mapView: GMSMapView!
    
    @IBOutlet weak var noeventsVw: UIView!
    
    let marker = GMSMarker()
    //payment
    var razorpayObj : RazorpayCheckout? = nil
    var razorPayOrderID = String()
    var razorpayTestKey:String = "rzp_test_FPkLi6StoPPcfK"
    var totalPrice:Double = 0.0
    var isfromHome:Bool?
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ShowavailableEvents()
        hideshowViews()
        registerCells()
        mapupdate()
    }
    func showMarker(position: CLLocationCoordinate2D){
            marker.position = position
            marker.map = mapView
        }
    func mapupdate()  {
        let lati = Double(lat) ?? 37.36
        let longi = Double(lng) ?? -122.0
        
        let camera = GMSCameraPosition.camera(withLatitude: lati, longitude: longi, zoom: 20)
        mapView.camera = camera
        showMarker(position: camera.target)
        
    }
    func hideshowViews()  {
        bookCardVw.isHidden = true
        eventlist.isHidden = false
        let color = UIColor(red: 243/255, green: 194/255, blue: 69/255, alpha: 1)
        
        bookBtn.layer.borderColor = color.cgColor
        bookBtn.layer.borderWidth = 1.5
        
        entryView.isHidden = true
        selectEntry.isHidden = true
        bookingVw.isHidden = true
        locationView.isHidden = true
    }
    func registerCells()  {
        selectEntryList.register(UINib(nibName: "SelectEntryCell", bundle: nil), forCellReuseIdentifier: "SelectEntryCell")
        bookinglistTable.register(UINib(nibName: "Memberselection", bundle: nil), forCellReuseIdentifier: "Memberselection")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isfromHome == true{
        self.tabBarController?.tabBar.isHidden = true
        let backButton = UIBarButtonItem()
            backButton.title = "Events"
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        }else{
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        self.addLeftBarbtnIcon(named: "logo_Icon")
        }
    }
    
    func ShowavailableEvents() {
        showSwiftLoader()
        let constants = Constants()
        
        let url = "\(constants.baseUrl)/ws/getVendorEvents?=&vendorUUID=\(vendorUUID)"
        AF.request(url, method: .get, parameters:nil, encoding: JSONEncoding.default)
               .responseJSON { response in
                   self.hideSwiftLoader()
                
                do{
                   
                    
                    let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: []) as? NSDictionary ?? [:]
                    let dataArr = jsonResult["data"] as? NSArray
                    
                    self.eventsArr = dataArr
                    if self.eventsArr.count != 0 {
                        self.noeventsVw.isHidden = true
                        self.navigationController?.isNavigationBarHidden = false
                    }else{
                        self.noeventsVw.isHidden = false
                        self.navigationController?.isNavigationBarHidden = true
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.eventlist.delegate = self
                        self.eventlist.dataSource = self
                        self.eventlist.reloadData()
                        
                    }
                    
                    
                    
                }
                catch{
                    
                }
        }
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
    func getCountandprice()  {
  
        
        let constants = Constants()
        let url = "\(constants.baseUrl)/ws/getEventTickets?=&eventUUID=\(self.event_uuid)&categoryType=\(self.entrytype)"
        AF.request(url, method: .get, parameters:nil, encoding: JSONEncoding.default)
            .responseJSON { response in
               
                do{
                    let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: []) as? NSDictionary ?? [:]
                    self.entryArr = jsonResult["data"] as? NSArray
                    
                    
                    DispatchQueue.main.async {
                        self.selectEntryList.delegate = self
                        self.selectEntryList.dataSource = self
                        self.selectEntryList.reloadData()
                    }
                    
                }catch{
                    
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
    func placeOrder(){
        showSwiftLoader()
        self.totalPrice = Double(self.currency * self.selectedMembers)
        print("amount:\(totalPrice)")

       
         let constants = Constants()

          let paymentInfo = ["cartAmount":"\(self.totalPrice)","currency":"INR"]
         GenerateOrderIDParser.RazorpayGenerateOrderAPI(xUsername: constants.xUsername,xPassword: constants.xPassword,patymentInfo: paymentInfo){(responce) in
             self.hideSwiftLoader()
             let orderId = responce.getOrderIdModel?.first?.orderId ?? String()
             self.razorPayOrderID = orderId
             print("a3\(self.razorPayOrderID)")

                 DispatchQueue.main.async {
                    
                     self.showPaymentForm(orderId: orderId)
                 }


         }

     }
    
    @IBAction func dismissView(_ sender: Any) {
        self.bookCardVw.isHidden = true
        self.eventlist.isHidden = false
    }
    
    @IBAction func bookAction(_ sender: Any) {
        self.entryView.isHidden = false
    }
    
    @IBAction func chooseLevel(_ sender: CustomButton) {
        if sender.tag == 0 {
            self.entrytype = "stag"
            self.selectEntryLbl.text = "Stag"
        }else if sender.tag == 1{
            self.entrytype = "couple"
            self.selectEntryLbl.text = "Couple"
        }else {
            self.entrytype = "singlelady"
            self.selectEntryLbl.text = "Single Lady"
        }
        self.selectEntry.isHidden = false
        
        getCountandprice()
    }
   
    
    @IBAction func cacleAct(_ sender: Any) {
        self.entryView.isHidden = true
    }
    
    @IBAction func cancleselectVW(_ sender: Any) {
        self.selectEntry.isHidden = true
    }
    
    @IBAction func hidebookVw(_ sender: Any) {
        self.bookingVw.isHidden = true
    }
    
    @IBAction func closelocation(_ sender: Any) {
        locationView.isHidden = true
    }
    
    @IBAction func payment(_ sender: Any) {
        if self.user_uuid != "" {
            self.placeOrder()
        }
        else{
            var loginCon = LoginController()
            loginCon = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            loginCon.navCon = self.navigationController!
            self.present(loginCon, animated: true)
        }
        
    }
    
    @IBAction func clubsAction(_ sender: Any) {
//        tabBarScreen = "home"
//        self.tabBarController?.selectedIndex = 0
        print("test")
        resetRoot()
        
       
    }
    func resetRoot() {
                guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as? TabViewController else {
                    return
                }
               
                 UIApplication.shared.windows.first?.rootViewController = rootVC
                UIApplication.shared.windows.first?.makeKeyAndVisible()
         }
    
}


class EventsCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var imagView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var datetimeLbl: UILabel!
    
    @IBOutlet weak var cityLbl: UILabel!
    
    
    override func awakeFromNib(){
        super.awakeFromNib()
        cardView.layer.cornerRadius = 15
        cardView.clipsToBounds = true
    }
}
extension ClubEventsController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == eventlist{
            return eventsArr.count
        }
        else if tableView == selectEntryList{
            return entryArr?.count ?? 0
        }else{
            return maxAllowed
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == eventlist{
            let cell = eventlist.dequeueReusableCell(withIdentifier: "EventsCell") as! EventsCell
            
            let date = (eventsArr[indexPath.row] as! NSDictionary).object(forKey: "date") as? Int ?? 0
            let day = (eventsArr[indexPath.row] as! NSDictionary).object(forKey: "day") as? String ?? ""
            let month = (eventsArr[indexPath.row] as! NSDictionary).object(forKey: "month") as? String ?? ""
            
            
            let time = (eventsArr[indexPath.row] as! NSDictionary).object(forKey: "time") as? String ?? ""
            cell.datetimeLbl.text = "\(time) "
            let location = (eventsArr[indexPath.row] as! NSDictionary).object(forKey: "eventLocation") as? String
            cell.cityLbl.text = location
            self.marker.title = location
            
            let normalAttri = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
            let dateAttri = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
            let dayAtStr = NSMutableAttributedString(string: "\(day) \n", attributes: normalAttri)
            let dateAtr = NSMutableAttributedString(string: "\(date) \n", attributes: dateAttri)
            let monthAtr = NSMutableAttributedString(string: "\(month)", attributes: normalAttri)
            let combination = NSMutableAttributedString()
            combination.append(dayAtStr)
            combination.append(dateAtr)
            combination.append(monthAtr)
            
            cell.titleLbl.attributedText = combination
            let constants = Constants()
            let image = (eventsArr[indexPath.row] as! NSDictionary).object(forKey: "eventImage") as? String
            print("\(constants.baseUrl)\(image!)")
            self.imageFromServerURL(URLString: "\(constants.baseUrl)\(image!)", placeHolder: UIImage(named: ""), imageView: cell.imagView)
            
            
            return cell
        }else if tableView == selectEntryList {
             guard let selectCell = selectEntryList.dequeueReusableCell(withIdentifier: "SelectEntryCell") as? SelectEntryCell else {return UITableViewCell()}
            let title = (self.entryArr?[indexPath.row]as! NSDictionary).object(forKey: "ticketDescription") as? String ?? ""
            let currencystr = (self.entryArr?[indexPath.row]as! NSDictionary).object(forKey: "ticketAmount") as? Int ?? 0
            
            let black = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
            let white = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
            selectCell.titleBtn.setTitle(title, for: .normal)
            let curencySymbol = NSMutableAttributedString(string: "₹", attributes: black)
            let currency = NSMutableAttributedString(string: " \(currencystr)", attributes: white)
            let combination = NSMutableAttributedString()
            combination.append(curencySymbol)
            combination.append(currency)
            selectCell.amountLbl.attributedText = combination
            
            return selectCell
            
            
        }else{
            guard let Cell = bookinglistTable.dequeueReusableCell(withIdentifier: "Memberselection") as? Memberselection else {return UITableViewCell()}
            Cell.memLbl.text = String(indexPath.row + 1)
            return Cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == eventlist{
            return 202
        }
        else if tableView == selectEntryList{
            return 140
        }else {
            return 45
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == eventlist{
            self.event_uuid = (eventsArr[indexPath.row] as! NSDictionary).object(forKey: "eventUUID") as? String ?? ""
            eventlist.isHidden = true
            let constants = Constants()
            self.event_img = (eventsArr[indexPath.row] as! NSDictionary).object(forKey: "eventImage") as? String ?? ""
            self.bookCardVw.isHidden = false
            self.imageFromServerURL(URLString: "\(constants.baseUrl)\(self.event_img)", placeHolder: UIImage(named: ""), imageView: self.imgVw)
            
            self.event_name = (eventsArr[indexPath.row] as! NSDictionary).object(forKey: "eventName") as? String ?? ""
            self.event_loca = (eventsArr[indexPath.row] as! NSDictionary).object(forKey: "eventLocation") as? String ?? ""
            self.user_uuid = UserDefaults.standard.object(forKey: "userUUID") as? String ?? ""
        }else if tableView == selectEntryList{
            self.maxAllowed = (self.entryArr?[indexPath.row]as! NSDictionary).object(forKey: "maxBookingAllowed") as? Int ?? 0
            self.bookvwTitle.text = "MAX BOOKINGS \(self.maxAllowed)"
            currency = (self.entryArr?[indexPath.row]as! NSDictionary).object(forKey: "ticketAmount") as? Int ?? 0
            bookingVw.isHidden = false
            self.bookinglistTable.delegate = self
            self.bookinglistTable.dataSource = self
            self.bookinglistTable.reloadData()
            
        }else{
            self.selectedMembers = indexPath.row + 1
            print(self.selectedMembers)
            locationView.isHidden = false
            entryView.isHidden = true
            selectEntry.isHidden = true
            bookingVw.isHidden = true
            
            self.clubNameLbl.text = self.event_name
            self.addrLbl.text = self.event_loca
            self.addresLbl.text = self.event_loca
            
        }
//
//        if userUUID != nil {
//            let story = UIStoryboard(name: "Main", bundle: nil)
//            let eventDetails = story.instantiateViewController(withIdentifier: "EventDetailsController") as! EventDetailsController
//            eventDetails.eventName = eventname
//            eventDetails.eventImage = image
//            eventDetails.eventUUId = eventUUid ?? ""
//            self.navigationController?.pushViewController(eventDetails, animated: true)
//        }
//        else{
//            var loginCon = LoginController()
//            loginCon = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
//            loginCon.navCon = self.navigationController!
//            self.present(loginCon, animated: true)
//        }
//
        
        
        
    }
    
}



extension ClubEventsController : RazorpayPaymentCompletionProtocol{
    func onPaymentError(_ code: Int32, description str: String) {
        print(str)
        print(code)
    }
   
    func onPaymentSuccess(_ payment_id: String) {
        
        self.completVc()
    }
    
    internal func showPaymentForm(orderId:String){
        let paisaTotal = self.totalPrice * 100
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
        isAnimationFalse = true
        self.tabBarController?.tabBar.isHidden = true
        razorpayObj?.open(options, displayController: self)
    }
    func completVc()  {
       
        let story = UIStoryboard(name: "Main", bundle: nil)
        let payementSucces = story.instantiateViewController(withIdentifier: "PaymentSuccess") as! PaymentSuccess
        self.navigationController?.pushViewController(payementSucces, animated: true)
        
        
    }

    
}

