//
//  PickDateAndTimeController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 01/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import Stepperier
import CoreLocation
var menRatio : Int = 0
var womenRatio : Int = 0
var isEntryRistricted: String = ""
class PickDateAndTimeController: UIViewController {
    lazy var tutorialVC: KJOverlayTutorialViewController = {
      return KJOverlayTutorialViewController()
    }()
    var height: CGFloat = 300
    var topCornerRadius: CGFloat = 35
    var presentDuration: Double = 1.5
    var dismissDuration: Double = 1.5
    var packageName = String()
    var passableDates = Array<String>()
    var imgUrl = String()
    var quantity:Double = 1
    var datesArray = Array<String>()
    var timeSlotsArray = Array<String>()
    var checkDatesArray = Array<Bool>()
    var checkTimeSlotsArray = Array<Bool>()
    var xeroxDateArray = Array<String>()
    var xeroxTimeSlotsArray = Array<String>()
    let imageCache = NSCache<AnyObject, AnyObject>()
    var price = Double()
    var bottleName = String()
    var masterServiceUUID = String()
    var vendorId = String()
    var serviceType = String()
    var itemsOffered = NSArray()
    var menuItem = NSArray()
    var menuItemUUID = NSArray()
    var menuItemsList = NSArray()
    var type = String()
   
    var getServicesListModel:GetServicesListModel!
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    var supriseName = Array<String>()
    var supriseUUID = Array<String>()
    var occationSupriseName = Array<String>()
    var occationSupriseUUID = Array<String>()
    var supriseOccationUUID = String()
    var supriseReceieverUUID = String()
    var noteForLovedOnes = String()
    var surpriseOccationName = String()
    var surpriseReceieverName = String()
    var guestsAllowed = Int()
    let dateFormatter : DateFormatter = DateFormatter()
    let timeformate: DateFormatter = DateFormatter()
    var selecteddate = ""
    var selectedtime = ""
    struct Issue:Codable {
        let title: String
        let createdAt:Date
   
    }
    var datetime = ""
    var currentdate = ""
    var currenttime = ""
    var finaldatesArr = [String]()
    var finaltimesArr = [String]()
    
    
    
    
    
    @IBOutlet weak var addTocartBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableviewcellRegistration()
        self.addTocartBtn.isHidden = true
        currentTime()
       
        addTocartBtn.layer.cornerRadius = 25
        print(type)
        self.supriseName = self.getServicesListModel.surpriseName.first  as? Array<String> ?? Array<String>()
        self.supriseUUID = self.getServicesListModel.surpriseUUID.first as? Array<String> ?? Array<String>()
        self.occationSupriseName = self.getServicesListModel.occationSupriseName.first  as? Array<String> ?? Array<String>()
        self.occationSupriseUUID = self.getServicesListModel.occationSupriseUUID.first  as? Array<String> ?? Array<String>()
        print(self.supriseName)
        print(self.supriseUUID)
        print(self.occationSupriseName)
        print(self.occationSupriseUUID)
        UserDefaults.standard.set(false, forKey: "login")
        isAnimationFalse = true
        print("dateArr:\(self.datesArray)")
        
        print("picktime:\(self.timeSlotsArray)")
        let backButton = UIBarButtonItem()
        backButton.title = "Add to Cart"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.xeroxDateArray = self.datesArray
        self.xeroxTimeSlotsArray = self.timeSlotsArray
//        self.datesArray = []
//        self.timeSlotsArray = []
        self.radioBtnChecker()
        self.radioBtrChecker()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if serviceType == "The WayU Party"{
            let barButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "package"), style: .plain, target: self, action: #selector(navigateToPackagesController))
            let menWomenRatio = UIBarButtonItem.init(image: UIImage.init(named: "M&W"), style: .plain, target:self , action: #selector(menWomenRationClicked))
            self.navigationItem.rightBarButtonItems = [barButtonItem, menWomenRatio]
            return
        }
        if self.type == "Make It Personal"{
            self.setUpRightBarBtnItems()
            return
        }
        if isEntryRistricted == "Y"{
            let menWomenRatio = UIBarButtonItem.init(image: UIImage.init(named: "M&W"), style: .plain, target:self , action: #selector(menWomenRationClicked))
            self.navigationItem.rightBarButtonItem = menWomenRatio
        }
       
        
    }
    func tableviewcellRegistration()  {
        let nib = UINib(nibName: "AddtocartCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AddtocartCell")
        
    }
   /*get date time by lat,longs**/
    func currentTime()  {
      
        let offset = TimeZone.current.secondsFromGMT()
        print(offset)
        let lati = Double(lat)
        let longi = Double(lng)
        let loc = CLLocation.init(latitude: lati!, longitude: longi!)//Paris's lon/lat
        let coder = CLGeocoder();
        coder.reverseGeocodeLocation(loc) { (placemarks, error) in
                    let place = placemarks?.last;
                    let newOffset = place?.timeZone?.secondsFromGMT()

                    let nowUTC = Date()
                    guard let localDate = Calendar.current.date(byAdding: .second, value: Int(newOffset ?? 0), to: nowUTC) else {return}
                        var currentdate = Date()
                             currentdate = localDate
            print(currentdate)
             
            let issue = Issue(title: "My date", createdAt: currentdate)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            encoder.dateEncodingStrategy = .iso8601
            let data = try! encoder.encode(issue)
            self.datetime = String(data:data,encoding: .utf8)!
            print(self.datetime)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.getdatetimestring()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    self.datetimecompareArrys()
                    
                }
            }

        }
    }
    
    
    
    /*datetime String**/
    func getdatetimestring()  {
        let data = Data(self.datetime.utf8)
        
        do{
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
           
            let feeddata = (json as AnyObject).object(forKey: "createdAt") as! String
            print(feeddata)
            let datesArr = feeddata.components(separatedBy: "T")
            currentdate = datesArr[0]
            print(currentdate)
            
            let timer = datesArr[1]
           
            let timeArr = timer.components(separatedBy: "Z")
            
            let timecompon = timeArr[0]
            let timecomponArr = timecompon.components(separatedBy: ":")
            let hour = timecomponArr[0]
            let minutes = timecomponArr[1]
            currenttime = "\(hour):\(minutes)"
            
            print(currenttime)
            
            
        }
      
    }
    /*Date time comparision*/
    func datetimecompareArrys()  {
       
        let date = self.currentdate
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateString = df.date(from: date)!
        
        let dateformater = DateFormatter()
        dateformater.dateFormat = "dd-MMM-yyyy"
        let datestr = dateformater.string(from: dateString)
        self.finaldatesArr.append(datestr)
        
        for i in 0..<self.xeroxDateArray.count {
            let dates = self.xeroxDateArray[i]
            var found = false
              while !found && dates >= datestr{
               found = true
               print("Daterr:\(dates)")
             
                }
                if found {
                    self.finaldatesArr.append(dates)
                }
            
        }
        
        DispatchQueue.main.async {
            
           
            
            let date = self.currenttime
            let df = DateFormatter()
            df.dateFormat = "HH:mm"
            let dateString = df.date(from: date)!
            
            let dateformater = DateFormatter()
            dateformater.dateFormat = "HH:mm a"
            let timestr = dateformater.string(from: dateString)
            print(timestr)
                        
            for i in 0..<self.xeroxTimeSlotsArray.count{
                let timesArr = self.xeroxTimeSlotsArray[i]
                
                var found = false
                  while !found && timesArr >= timestr {
                   found = true
                   print("Daterr:\(timesArr)")
                 
                    }
                    if found {
                       
                        
                        self.finaltimesArr.append(timesArr)
                    }
            }
            
        }
    }
    @objc func setUpRightBarBtnItems(){
        let supriseBtn = UIBarButtonItem.init(image: UIImage.init(named: "suprise"), style: .plain, target: self, action: #selector(SupriseBtnAction))
        let occationBtn = UIBarButtonItem.init(image: UIImage.init(named: "occation"), style: .plain, target: self, action: #selector(OccationBtnAction))
        let noteBtn = UIBarButtonItem.init(image: UIImage.init(named: "note"), style: .plain, target: self, action: #selector(noteBtnAction))
        self.navigationItem.rightBarButtonItems = [supriseBtn,occationBtn,noteBtn]
    }
    
    @objc func menWomenRationClicked(){
        self.presentPopUpScreen(popTitle: "Resuarent has entry restriction.Please select guests")
    }
    
    @objc func SupriseBtnAction(){
         let redAppearance = YBTextPickerAppearanceManager.init(
                pickerTitle         : type,
                titleFont           : boldFont,
                titleTextColor      : UIColor.init(red: 186.0/255.0, green: 156.0/255.0, blue: 93.0/255.0, alpha: 1.0),
                titleBackground     : UIColor.black,
                searchBarFont       : regularFont,
                searchBarPlaceholder: "Search Type",
                closeButtonTitle    : "Cancel",
                closeButtonColor    : .white,
                closeButtonFont     : regularFont,
                //doneButtonTitle     : "Okay",
                //doneButtonColor     : UIColor.init(red: 74.0/255.0, green: 157.0/255.0, blue: 100.0/255.0, alpha: 1.0),
               // doneButtonFont      : boldFont,
                //checkMarkPosition   : .Right,
                //itemCheckedImage    : UIImage(named:"radio"),
                //itemUncheckedImage  : UIImage(named:"radioNCW"),
                itemColor           : .black,
                itemFont            : regularFont
            )
        let arrGender = self.occationSupriseName
        let picker = YBTextPicker.init(with: arrGender, appearance: redAppearance,onCompletion: { (selectedIndexes, selectedValues) in
            if let selectedValue = selectedValues.first{
                self.supriseOccationUUID = self.occationSupriseUUID[selectedIndexes.first!]
                self.surpriseOccationName = self.occationSupriseName[selectedIndexes.first!]
            print(selectedValue)
            }else{
            print("selction")
            }}, onCancel: {
                print("Cancelled")
                })
           picker.show(withAnimation: .FromBottom)
    }
    @objc func OccationBtnAction(){
        let redAppearance = YBTextPickerAppearanceManager.init(
               pickerTitle         : type,
               titleFont           : boldFont,
               titleTextColor      : UIColor.init(red: 186.0/255.0, green: 156.0/255.0, blue: 93.0/255.0, alpha: 1.0),
               titleBackground     : UIColor.black,
               searchBarFont       : regularFont,
               searchBarPlaceholder: "Search Type",
               closeButtonTitle    : "Cancel",
               closeButtonColor    : .white,
               closeButtonFont     : regularFont,
               
               itemColor           : .black,
               itemFont            : regularFont
           )
       let arrGender = self.supriseName
       let picker = YBTextPicker.init(with: arrGender, appearance: redAppearance,onCompletion: { (selectedIndexes, selectedValues) in
           if let selectedValue = selectedValues.first{
               self.supriseReceieverUUID = self.supriseUUID[selectedIndexes.first!]
            self.surpriseReceieverName = self.supriseName [selectedIndexes.first!]
           print(selectedValue)
           }else{
           print("selction")
           }}, onCancel: {
               print("Cancelled")
        })
          picker.show(withAnimation: .FromBottom)
    }
    @objc func noteBtnAction(){
        promptForAnswer()
    }
    
    func presentPopUpScreen(popTitle:String){
    guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "MenWomenRatioController") as? MenWomenRatioController else { return }
        popupVC.height = height
        popupVC.topCornerRadius = topCornerRadius
        popupVC.presentDuration = presentDuration
        popupVC.dismissDuration = dismissDuration
        popupVC.popUpTitleStr = popTitle
        popupVC.popupDelegate = self
        present(popupVC, animated: true, completion: nil)
    }

    
    
    
    
    func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Note", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            self.noteForLovedOnes = answer.text ?? "No text"
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func navigateToPackagesController(){
        var packageCon = PackagesController()
        packageCon = self.storyboard?.instantiateViewController(withIdentifier: "PackagesController") as! PackagesController
        packageCon.itemsOffered = self.itemsOffered
        packageCon.menuItemUUID = self.menuItemUUID
        print(menuItem)
        packageCon.menuItem = self.menuItem
        packageCon.menuItemsList = self.menuItemsList
        packageCon.packageName = self.packageName
        self.navigationController?.pushViewController(packageCon, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.serviceType == "Packages"{
            let userSeenTutorial = UserDefaults.standard.bool(forKey: "UserSeenTutorial")
            if userSeenTutorial == true{}
            else{
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
              UserDefaults.standard.set(true, forKey: "UserSeenTutorial")
              self.showTutorial()
            }}
        }
        if self.type == "Surprise"{
            let userSeenTutorial = UserDefaults.standard.bool(forKey: "UserSeenSupriseTutorial")
            if userSeenTutorial == true{}
            else{
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
              UserDefaults.standard.set(true, forKey: "UserSeenSupriseTutorial")
              self.showTutorialForSuprises()
            }}
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("MLNotification"), object: nil)
        
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: selectedIndexPath) as! HeaderCell
        let notiuerinfo = notification.userInfo?["selectedValue"] as? String ?? ""
        if notiuerinfo != ""{
            cell.mlTf.text = notiuerinfo
            print("Value of notification : ", notiuerinfo)
        }else{
            cell.mlTf.text = ""
        }
            
        }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
   
    func showTutorial() {
      
        var focusRect1 = CGRect()
        if UIScreen.main.bounds.size.height == 568.0{focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-50, y: 20, width:40, height: 44)}
        if UIScreen.main.bounds.size.height == 667.0{
            focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-50, y: 20, width:40, height: 44)
        }
            if UIScreen.main.bounds.size.height == 812.0 {
        focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-50, y: 40, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 896{
            focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-55, y: 40, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 844{
            focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-50, y: 45, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 926.0{
            focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-55, y: 45, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 736.0{
            focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-55, y: 20, width:40, height: 44)
        }

      let icon1Frame = CGRect(x: self.view.bounds.width/2-72/2, y: (focusRect1.maxY ) + 12, width: 72, height: 72)
      let message1 = "Customise package here and proceed to cart"
      let message1Center = CGPoint(x: self.view.bounds.width/2, y: icon1Frame.maxY + 24)
      var tut1 = KJTutorial.textTutorial(focusRectangle: focusRect1 , text: message1, textPosition: message1Center)
      tut1.isArrowHidden = false
      
      // tuts
      let tutorials = [tut1]
      self.tutorialVC.tutorials = tutorials
      self.tutorialVC.showInViewController(self)
    }
    
    func radioBtnChecker(){
        checkDatesArray.removeAll()
        for _ in 0..<xeroxDateArray.count{
            checkDatesArray.append(false)
        }
    }
   
    func radioBtrChecker(){
        checkTimeSlotsArray.removeAll()
        for _ in 0..<xeroxTimeSlotsArray.count{
            
            checkTimeSlotsArray.append(false)
        }
    }
    
    
    @IBAction func addToCartAction(_ sender: UIButton) {
        print(serviceType)
        print("menratio:------\(self.guestsAllowed)")
        if isEntryRistricted == "Y"{
            if !(womenRatio >= menRatio - womenRatio) || menRatio == 0  && womenRatio == 0 || womenRatio + menRatio > self.guestsAllowed*Int(self.quantity){
                print("Please Satisfy the protocol")
                self.presentPopUpScreen(popTitle: "Resuarent has entry restriction.\(self.guestsAllowed) Guests allowed per bottle.stags not allowed")
            }
           else{
                if serviceType == "The WayU Party" || self.type == "Make It Personal" && packagesDict.keys.isEmpty && packageMenuItems == "" {
                        if self.type == "Make It Personal"{
                            if self.noteForLovedOnes == "" || self.supriseOccationUUID == "" || self.supriseReceieverUUID == ""{
                            self.showTutorialForSuprises()
                                return
                            }
                        }
                        if self.serviceType == "The WayU Party" && packagesDict.keys.isEmpty && packageMenuItems == "" {
                            self.showTutorial()
                            return
                        }
                }
                    let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String
//                    var serviceDate = String()
//                    var timeSlot = String()
//                    for i in 0..<self.checkDatesArray.count{
//                        let boolCheck = self.checkDatesArray[i]
//                        if boolCheck == true{
//                            serviceDate = self.passableDates[i]
//                        }
//                    }
//                    for i in 0..<self.checkTimeSlotsArray.count{
//                        let boolCheck = self.checkTimeSlotsArray[i]
//                        if boolCheck == true{
//                            timeSlot = self.xeroxTimeSlotsArray[i]
//                        }
//                    }
                var supriseDetails = Array<String>()
                if supriseOccationUUID == "" || supriseReceieverUUID == ""{
                    
                }else{
                    supriseDetails.append(supriseOccationUUID)
                    supriseDetails.append(supriseReceieverUUID)
                }
            
           
//            dateFormatter.dateFormat = "dd/MM/yyyy"
//            let date = Date()
//            let dateString = dateFormatter.string(from: date)
//            print(dateString)
//            timeformate.dateFormat = "HH:mm"
//            let timestring = timeformate.string(from: date)
//            print("24hours:\(timestring)")
//            let myInt = (timestring as NSString).floatValue
//            print("timestring:\(myInt)")
            /*24 hours**/
            
           
           
//            let lasttime = timeSlot.components(separatedBy: " to ")
//            let times =  lasttime[1]
//            //let timestrings:String = times
//
//
//            let datersString = times
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "h:mm a"
//            let daters = dateFormatter.date(from: datersString)
//            dateFormatter.dateFormat = "HH:mm"
//            let Date24 = dateFormatter.string(from: daters!)
//            print("24timeslot:\(Date24)")
//            let myInt1 = (Date24 as NSString).floatValue
//            print("24 hour formatted Date:",myInt1)
           
            
           
            
         //  if dateString == serviceDate {
//                if Date24 > timestring {
//
//                    let cartData = ["userUUID":userUUID,
//                    "masterServiceUUID":self.masterServiceUUID,
//                    "vendorUUID":self.vendorId,
//                    "serviceOrderDate":serviceDate,
//                    "timeslot":timeSlot,
//                    "orderAmount":"\(self.price)",
//                    "quantity":"\(Int(self.quantity))",
//                    "totalAmount":"\(self.price * self.quantity)",
//                    "currency":"INR","packageMenuItems":packageMenuItems,"surpriseDetails":"\(supriseDetails.joined(separator: ","))","surpriseInstructions":"\(self.noteForLovedOnes)"]
//                let constants = Constants()
//                AddToCartParser.AddToCartParser(cartData: cartData as [String : Any], xUsername: "\(constants.xUsername)", xPassword: "\(constants.xPassword)"){(responce) in
//                        let message = responce.addToCartModel.first?.responce ?? String()
//                        if message == "SUCCESS"{
//                            packagesDict = [:]
//                            packageMenuItems = ""
//                             menRatio = 0
//                             womenRatio = 0
//                         DispatchQueue.main.async {
//                            tabBarScreen = "cart"
//                            self.tabBarController?.selectedIndex = 1
//                            }
//                        }
//                        else{
//                            let msg = responce.addToCartModel.first?.responseMessage as? String
//                            DispatchQueue.main.async {
//                                let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
//                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                                self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                }
//                }
//                else{
//                showToastatbottom(message: "not available at this time slot")
//                }
//            }
            //else{
           // print("time:\(timeSlot)")
            print(selectedtime)
            print(selecteddate)
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd-MMM-yyyy"
            let showDate = inputFormatter.date(from: selecteddate)
            if showDate != nil{
            inputFormatter.dateFormat = "dd/MM/yyyy"
            let resultString = inputFormatter.string(from: showDate!)
            print("monkey:\(resultString)")
                    let cartData = ["userUUID":userUUID,
                    "masterServiceUUID":self.masterServiceUUID,
                    "vendorUUID":self.vendorId,
                    "serviceOrderDate":resultString,
                    "timeslot":selectedtime,
                    "orderAmount":"\(self.price)",
                    "quantity":"\(Int(self.quantity))",
                    "totalAmount":"\(self.price * self.quantity)",
                    "currency":"INR","packageMenuItems":packageMenuItems,"surpriseDetails":"\(supriseDetails.joined(separator: ","))","surpriseInstructions":"\(self.noteForLovedOnes)"]
                let constants = Constants()
                AddToCartParser.AddToCartParser(cartData: cartData as [String : Any], xUsername: "\(constants.xUsername)", xPassword: "\(constants.xPassword)"){(responce) in
                        let message = responce.addToCartModel.first?.responce ?? String()
                        if message == "SUCCESS"{
                            packagesDict = [:]
                            packageMenuItems = ""
                             menRatio = 0
                             womenRatio = 0
                         DispatchQueue.main.async {
                            tabBarScreen = "cart"
                            self.tabBarController?.selectedIndex = 1
                            }
                        }
                        else{
                            let msg = responce.addToCartModel.first?.responseMessage as? String
                            print("method:\(msg)")
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            else{
                showToastatbottom(message: "Select Date and Time!")
            }
        }
        }
        else{
            if serviceType == "The WayU Party" || self.type == "Make It Personal" && packagesDict.keys.isEmpty && packageMenuItems == "" {
               //DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if self.type == "Make It Personal"{
                        if self.noteForLovedOnes == "" || self.supriseOccationUUID == "" || self.supriseReceieverUUID == ""{
                        self.showTutorialForSuprises()
                            return
                        }
                    }
                    if self.serviceType == "The WayU Party" && packagesDict.keys.isEmpty && packageMenuItems == "" {
                        self.showTutorial()
                        return
                    }
                 
                //}
            
            }//else{
                let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String
//                var serviceDate = String()
//                var timeSlot = String()
//                for i in 0..<self.checkDatesArray.count{
//                    let boolCheck = self.checkDatesArray[i]
//                    if boolCheck == true{
//                        serviceDate = self.passableDates[i]
//                    }
//                }
//                for i in 0..<self.checkTimeSlotsArray.count{
//                    let boolCheck = self.checkTimeSlotsArray[i]
//                    if boolCheck == true{
//                        timeSlot = self.xeroxTimeSlotsArray[i]
//                    }
//                }
            var supriseDetails = Array<String>()
            if supriseOccationUUID == "" || supriseReceieverUUID == ""{
                
            }else{
                supriseDetails.append(supriseOccationUUID)
                supriseDetails.append(supriseReceieverUUID)
            }
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd-MMM-yyyy"
            let showDate = inputFormatter.date(from: selecteddate)
            if showDate != nil{
            inputFormatter.dateFormat = "dd/MM/yyyy"
            let resultString = inputFormatter.string(from: showDate!)
                let cartData = ["userUUID":userUUID,
                "masterServiceUUID":self.masterServiceUUID,
                "vendorUUID":self.vendorId,
                "serviceOrderDate":resultString,
                "timeslot":selectedtime,
                "orderAmount":"\(self.price)",
                "quantity":"\(Int(self.quantity))",
                "totalAmount":"\(self.price * self.quantity)",
                "currency":"INR","packageMenuItems":packageMenuItems,"surpriseDetails":"\(supriseDetails.joined(separator: ","))","surpriseInstructions":"\(self.noteForLovedOnes)"]
                 let constants = Constants()
            AddToCartParser.AddToCartParser(cartData: cartData as [String : Any], xUsername: "\(constants.xUsername)", xPassword: "\(constants.xPassword)"){(responce) in
                    let message = responce.addToCartModel.first?.responce ?? String()
                    if message == "SUCCESS"{
                        packagesDict = [:]
                        packageMenuItems = ""
                     DispatchQueue.main.async {
                        tabBarScreen = "cart"
                        self.tabBarController?.selectedIndex = 1
                        }
                    }
                    else{
                        let msg = responce.addToCartModel.first?.responseMessage as? String
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            else{
                showToastatbottom(message: "Select Date and Time!")
            }
        }
    }
    
    @objc func addtoCartAction(){
        print(serviceType)
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: selectedIndexPath) as! HeaderCell
        if isEntryRistricted == "Y"{
            if !(womenRatio >= menRatio - womenRatio) || menRatio == 0  && womenRatio == 0 || womenRatio + menRatio > self.guestsAllowed*Int(self.quantity){
                print("Please Satisfy the protocol")
                self.presentPopUpScreen(popTitle: "Resuarent has entry restriction.\(self.guestsAllowed) Guests allowed per bottle.stags not allowed")
            }
           else{
                if serviceType == "The WayU Party" || self.type == "Make It Personal" && packagesDict.keys.isEmpty && packageMenuItems == "" {
                        if self.type == "Make It Personal"{
                            if self.noteForLovedOnes == "" || self.supriseOccationUUID == "" || self.supriseReceieverUUID == ""{
                            self.showTutorialForSuprises()
                                return
                            }
                        }
                        if self.serviceType == "The WayU Party" && packagesDict.keys.isEmpty && packageMenuItems == "" {
                            self.showTutorial()
                            return
                        }
                }
                    let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String

                var supriseDetails = Array<String>()
                if supriseOccationUUID == "" || supriseReceieverUUID == ""{
                    
                }else{
                    supriseDetails.append(supriseOccationUUID)
                    supriseDetails.append(supriseReceieverUUID)
                }
            
           

            print(selectedtime)
            print(selecteddate)
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd-MMM-yyyy"
            let showDate = inputFormatter.date(from: selecteddate)
            if showDate != nil{
            inputFormatter.dateFormat = "dd/MM/yyyy"
                 if serviceType == "Cheers"{
                    if cell.mlTf.text == ""{
                        self.showToastatbottom(message: "Please Select MLS")
                    }else{
                        let totalpriceArr = cell.mlTf.text!.components(separatedBy: " ")
                        let price = totalpriceArr[1]
                        let finalPriceArr = price.components(separatedBy: ":")
                        self.price = Double(finalPriceArr[1]) ?? 0.0
                       
                        let resultString = inputFormatter.string(from: showDate!)
                        print("monkey:\(resultString)")
                                let cartData = ["userUUID":userUUID,
                                "masterServiceUUID":self.masterServiceUUID,
                                "vendorUUID":self.vendorId,
                                "serviceOrderDate":resultString,
                                "timeslot":selectedtime,
                                "orderAmount":"\(self.price)",
                                "quantity":"\(Int(self.quantity))",
                                "totalAmount":"\(self.price * self.quantity)",
                                "currency":"INR","packageMenuItems":packageMenuItems,"surpriseDetails":"\(supriseDetails.joined(separator: ","))","surpriseInstructions":"\(self.noteForLovedOnes)"]
                            let constants = Constants()
                            AddToCartParser.AddToCartParser(cartData: cartData as [String : Any], xUsername: "\(constants.xUsername)", xPassword: "\(constants.xPassword)"){(responce) in
                                    let message = responce.addToCartModel.first?.responce ?? String()
                                    if message == "SUCCESS"{
                                        packagesDict = [:]
                                        packageMenuItems = ""
                                         menRatio = 0
                                         womenRatio = 0
                                     DispatchQueue.main.async {
                                        tabBarScreen = "cart"
                                        self.tabBarController?.selectedIndex = 1
                                        }
                                    }
                                    else{
                                        let msg = responce.addToCartModel.first?.responseMessage as? String
                                        print("method:\(msg)")
                                        DispatchQueue.main.async {
                                            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                        
                        //self.price
                    }
                    
                 }else{
                     let resultString = inputFormatter.string(from: showDate!)
                     print("monkey:\(resultString)")
                             let cartData = ["userUUID":userUUID,
                             "masterServiceUUID":self.masterServiceUUID,
                             "vendorUUID":self.vendorId,
                             "serviceOrderDate":resultString,
                             "timeslot":selectedtime,
                             "orderAmount":"\(self.price)",
                             "quantity":"\(Int(self.quantity))",
                             "totalAmount":"\(self.price * self.quantity)",
                             "currency":"INR","packageMenuItems":packageMenuItems,"surpriseDetails":"\(supriseDetails.joined(separator: ","))","surpriseInstructions":"\(self.noteForLovedOnes)"]
                         let constants = Constants()
                         AddToCartParser.AddToCartParser(cartData: cartData as [String : Any], xUsername: "\(constants.xUsername)", xPassword: "\(constants.xPassword)"){(responce) in
                                 let message = responce.addToCartModel.first?.responce ?? String()
                                 if message == "SUCCESS"{
                                     packagesDict = [:]
                                     packageMenuItems = ""
                                      menRatio = 0
                                      womenRatio = 0
                                  DispatchQueue.main.async {
                                     tabBarScreen = "cart"
                                     self.tabBarController?.selectedIndex = 1
                                     }
                                 }
                                 else{
                                     let msg = responce.addToCartModel.first?.responseMessage as? String
                                     print("method:\(msg)")
                                     DispatchQueue.main.async {
                                         let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
                                         alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                         self.present(alert, animated: true, completion: nil)
                                 }
                             }
                         }
                 }
           
            }
            else{
                showToastatbottom(message: "Select Date and Time!")
            }
        }
        }
        else{
            if serviceType == "The WayU Party" || self.type == "Make It Personal" && packagesDict.keys.isEmpty && packageMenuItems == "" {
               //DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if self.type == "Make It Personal"{
                        if self.noteForLovedOnes == "" || self.supriseOccationUUID == "" || self.supriseReceieverUUID == ""{
                        self.showTutorialForSuprises()
                            return
                        }
                    }
                    if self.serviceType == "The WayU Party" && packagesDict.keys.isEmpty && packageMenuItems == "" {
                        self.showTutorial()
                        return
                    }
                 
                //}
            
            }
                let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String

            var supriseDetails = Array<String>()
            if supriseOccationUUID == "" || supriseReceieverUUID == ""{
                
            }else{
                supriseDetails.append(supriseOccationUUID)
                supriseDetails.append(supriseReceieverUUID)
            }
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd-MMM-yyyy"
            let showDate = inputFormatter.date(from: selecteddate)
            if showDate != nil{
            inputFormatter.dateFormat = "dd/MM/yyyy"
            let resultString = inputFormatter.string(from: showDate!)
                let cartData = ["userUUID":userUUID,
                "masterServiceUUID":self.masterServiceUUID,
                "vendorUUID":self.vendorId,
                "serviceOrderDate":resultString,
                "timeslot":selectedtime,
                "orderAmount":"\(self.price)",
                "quantity":"\(Int(self.quantity))",
                "totalAmount":"\(self.price * self.quantity)",
                "currency":"INR","packageMenuItems":packageMenuItems,"surpriseDetails":"\(supriseDetails.joined(separator: ","))","surpriseInstructions":"\(self.noteForLovedOnes)"]
                 let constants = Constants()
            AddToCartParser.AddToCartParser(cartData: cartData as [String : Any], xUsername: "\(constants.xUsername)", xPassword: "\(constants.xPassword)"){(responce) in
                    let message = responce.addToCartModel.first?.responce ?? String()
                    if message == "SUCCESS"{
                        packagesDict = [:]
                        packageMenuItems = ""
                     DispatchQueue.main.async {
                        tabBarScreen = "cart"
                        self.tabBarController?.selectedIndex = 1
                        }
                    }
                    else{
                        let msg = responce.addToCartModel.first?.responseMessage as? String
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            else{
                showToastatbottom(message: "Select Date and Time!")
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
    
   
}

class HeaderCell:UITableViewCell{
    @IBOutlet weak var surpriseInfoBtn: UIButton!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerTitleLbl: UILabel!
    @IBOutlet weak var headerPrize: UILabel!
    //@IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var supportViewStepper: UIView!
    @IBOutlet weak var stepperView: Stepperier!
    @IBOutlet weak var selectdateTF: UITextField!
    @IBOutlet weak var selecttimeTF: UITextField!
   
    var datesslots = Array<String>()
    var timeslots = Array<String>()
    
    @IBOutlet var selecttimeVw: UIView!
    
    @IBOutlet var selectMlVw: UIView!
    
    @IBOutlet var selectdateVw: UIView!
    
    @IBOutlet var guestLbl: UILabel!
    @IBOutlet var mlTf: UITextField!
    
    @IBOutlet var mlvwHeight: NSLayoutConstraint!
    override func awakeFromNib(){
      super.awakeFromNib()
      setuiElements()
     

     
      
        
    }
    func setuiElements()  {
        let dummyView = UIView()
        selectdateTF.inputView = dummyView
        selecttimeTF.inputView = dummyView
        selectdateTF.text = ""
        selecttimeTF.text = ""
        mlTf.text = ""
        
        selectdateTF.attributedPlaceholder = NSAttributedString(string: "Select Date",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        selecttimeTF.attributedPlaceholder = NSAttributedString(string: "Select time",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        mlTf.attributedPlaceholder = NSAttributedString(string: "Select ML",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        selectMlVw.layer.cornerRadius = 10
        selectdateVw.layer.cornerRadius = 10
        selecttimeVw.layer.cornerRadius = 10
        surpriseInfoBtn.isHidden = true
    }
    
   
    
}





extension PickDateAndTimeController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
   
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: selectedIndexPath) as! HeaderCell
        if textField == cell.selectdateTF {
            print("iytgg\(cell.datesslots)")
            //dateselection()
        }
        else if textField == cell.selecttimeTF{
            //Timeselection()
            
        }
        else if cell.selecttimeTF.text != ""{
            self.showToastatbottom(message: "Book Your Slot Now")
            
        }
        
    }
    
    
   

    @objc func someAction(_ sender:UITapGestureRecognizer){
        let mlpopupVC = SelectMlPopupVC(nibName: "SelectMlPopupVC", bundle: nil)
        mlpopupVC.modalPresentationStyle = .overCurrentContext
        self.present(mlpopupVC, animated: false)
        
    }
  @objc func dateselection(_ sender:UITapGestureRecognizer){
       
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: selectedIndexPath) as! HeaderCell
        let redAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Selecte Date",
            titleFont           : boldFont,
            //titleTextColor      : UIColor.white,
           // titleBackground     : UIColor.clear,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search Type",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .white,
            closeButtonFont     : regularFont,

            itemFont            : regularFont
           )






        let picker = YBTextPicker.init(with: self.datesArray, appearance: redAppearance,onCompletion: { (selectedIndexes, selectedValues) in
           if let selectedValue = selectedValues.first{
               cell.selectdateTF.text = selectedValue
               self.selecteddate = selectedValue

           print(selectedValue)
           }else{
           print("selction")
           }}, onCancel: {
               cell.selectdateTF.endEditing(true)
               print("Cancelled")
        })
          picker.show(withAnimation: .FromBottom)
    }
    @objc  func Timeselection(_ sender:UITapGestureRecognizer){
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: selectedIndexPath) as! HeaderCell
        let redAppearance = YBTextPickerAppearanceManager.init(
               pickerTitle         : "Select Time",
               titleFont           : boldFont,
               //titleTextColor      : UIColor.white,
              // titleBackground     : UIColor.clear,
               searchBarFont       : regularFont,
               searchBarPlaceholder: "Search Type",
               closeButtonTitle    : "Cancel",
               closeButtonColor    : .white,
               closeButtonFont     : regularFont,

               itemFont            : regularFont
           )
        if cell.selecttimeTF.text != "" {
           self.showToastatbottom(message: "Book Your Slot Now")
       }
       else if cell.selectdateTF.text != "" {
            let picker = YBTextPicker.init(with: self.timeSlotsArray, appearance: redAppearance,onCompletion: { (selectedIndexes, selectedValues) in
               if let selectedValue = selectedValues.first{
                   cell.selecttimeTF.text = selectedValue
                   self.selectedtime = selectedValue
                  
               print(selectedValue)
               }else{
               print("selction")
               }}, onCancel: {
                   print("Cancelled")
                   cell.selecttimeTF.endEditing(true)
            })
              picker.show(withAnimation: .FromBottom)
        }
         
        else{
            cell.selecttimeTF.endEditing(true)
            self.showToastatbottom(message: "Please Select Date first")
        }
        
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
            cell.datesslots = self.datesArray
            cell.timeslots = self.timeSlotsArray
            print("IUTy\(cell.timeslots)")
            let constants = Constants()
            self.imageFromServerURL(URLString: constants.baseUrl+self.imgUrl, placeHolder:UIImage.init(named: "beer.jpg"), imageView: cell.headerImageView)
            cell.headerImageView.layer.cornerRadius = 50
            cell.headerImageView.layer.borderColor = UIColor.white.cgColor
            cell.headerImageView.layer.borderWidth = 1.5
            cell.headerTitleLbl.text = self.bottleName
            cell.headerPrize.text = "Rs:\(self.price)"
            cell.supportViewStepper.layer.cornerRadius = 17.0
            cell.stepperView.value = Int(quantity)
            if self.type == "Cheers" || self.type == "Save the Seat" {
                cell.guestLbl.isHidden = false
                cell.guestLbl.text = "allowed: \(self.guestsAllowed) per quantity"
            }else{
                cell.guestLbl.isHidden = true
            }
            
            cell.stepperView.addTarget(self, action: #selector(stepperierValueDidChange), for: .valueChanged)
            
            cell.surpriseInfoBtn.addTarget(self, action: #selector(surpriseInfoBtnAction), for: .touchUpInside)
            // cell.selecttimeTF.delegate = self
            //cell.selectdateTF.delegate = self
            cell.selectMlVw.isUserInteractionEnabled = true
            cell.selectdateVw.isUserInteractionEnabled = true
            cell.selecttimeVw.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
            cell.selectMlVw.addGestureRecognizer(gesture)
            let timegesture = UITapGestureRecognizer(target: self, action:  #selector (self.Timeselection (_:)))
            cell.selecttimeVw.addGestureRecognizer(timegesture)
            let dategesture = UITapGestureRecognizer(target: self, action:  #selector (self.dateselection (_:)))
            cell.selectdateVw.addGestureRecognizer(dategesture)
            if self.type == "Cheers"{
                cell.mlvwHeight.constant = 40
                cell.mlTf.isHidden = false
                cell.selectMlVw.isHidden = false
                
            }else{
                cell.mlvwHeight.constant = 0
                cell.selectMlVw.isHidden = true
                cell.mlTf.isHidden = true
            }
            
            if self.type == "Make It Personal"{cell.surpriseInfoBtn.isHidden = false}else{cell.surpriseInfoBtn.isHidden = true}
            if self.type == "Deals" || self.type == "Make It Personal" || self.type == "Save the Seat" || self.type == "The WayU Party"{
                cell.stepperView.isUserInteractionEnabled = false
                cell.stepperView.alpha = 0.7
            }else{
                cell.stepperView.isUserInteractionEnabled = true
                cell.stepperView.alpha = 1.0
            }
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddtocartCell") as! AddtocartCell
            cell.addtocartBtn.addTarget(self, action: #selector(addtoCartAction), for: .touchUpInside)
            return cell
            
        }

   
    
    }
   
    @objc func stepperierValueDidChange(_ stepper: Stepperier) {
        if stepper.value == 0{
            quantity = 1
        }else{
            print("Updated value: \(stepper.value)")
            quantity = Double(stepper.value)
        }
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return 1
        }
       
            
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 293
        }else{
            return 55
        }
         
    }
    
   
    @objc func radionBtnAction(sender:UIButton){
        self.radioBtnChecker()
        if sender.isSelected == true{
            sender.isSelected = false
            
            checkDatesArray[sender.tag] = false
        }else{
            sender.isSelected = true
            
            checkDatesArray[sender.tag] = true
        }
        print(checkDatesArray)
        self.tableView.reloadData()
    }
    
    @objc func radionBtrAction(sender:UIButton){
        self.radioBtrChecker()
      if sender.isSelected == true{
            sender.isSelected = false
          
            checkTimeSlotsArray[sender.tag] = false
        }else{
            sender.isSelected = true
            
            checkTimeSlotsArray[sender.tag] = true
        }
        print(checkTimeSlotsArray)
        self.tableView.reloadData()
    }
    
    @objc func surpriseInfoBtnAction(){
        let alert = UIAlertController(title: "Suprise Instructions",
                                      message: "\n Occation: \(self.surpriseOccationName) \n\n Surprise-For: \(self.surpriseReceieverName) \n\n Note: \(noteForLovedOnes)\n\n ",
                                      preferredStyle: UIAlertController.Style.alert)

        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension PickDateAndTimeController{
    func showTutorialForSuprises(){
        
        var focusRect1 = CGRect()
        var focusRect2 = CGRect()
        var focusRect3 = CGRect()
        if UIScreen.main.bounds.size.height == 568.0{focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-50, y: 20, width:40, height: 44)}
        if UIScreen.main.bounds.size.height == 667.0{
            focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-50, y: 20, width:40, height: 44)
        }
            if UIScreen.main.bounds.size.height == 812.0 {
        focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-50, y: 40, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 896{
            focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-55, y: 40, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 844{
            focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-50, y: 45, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 926.0{
            focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-55, y: 45, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 736.0{
            focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-55, y: 20, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 568.0{focusRect2 = CGRect.init(x: UIScreen.main.bounds.size.width-80, y: 20, width:40, height: 44)}
        if UIScreen.main.bounds.size.height == 667.0{
            focusRect2 = CGRect.init(x: UIScreen.main.bounds.size.width-118, y: 20, width:40, height: 44)
        }
            if UIScreen.main.bounds.size.height == 812.0 {
        focusRect2 = CGRect.init(x: UIScreen.main.bounds.size.width-118, y: 40, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 896{
            focusRect2 = CGRect.init(x: UIScreen.main.bounds.size.width-122, y: 40, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 844{
            focusRect2 = CGRect.init(x: UIScreen.main.bounds.size.width-118, y: 45, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 926.0{
            focusRect2 = CGRect.init(x: UIScreen.main.bounds.size.width-122, y: 45, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 736.0{
            focusRect2 = CGRect.init(x: UIScreen.main.bounds.size.width-85, y: 20, width:40, height: 44)
        }
        
        
        if UIScreen.main.bounds.size.height == 568.0{focusRect3 = CGRect.init(x: UIScreen.main.bounds.size.width-80, y: 20, width:40, height: 44)}
        if UIScreen.main.bounds.size.height == 667.0{
            focusRect3 = CGRect.init(x: UIScreen.main.bounds.size.width-180, y: 20, width:40, height: 44)
        }
            if UIScreen.main.bounds.size.height == 812.0 {
                focusRect3 = CGRect.init(x: UIScreen.main.bounds.size.width-180, y: 40, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 896{
            focusRect3 = CGRect.init(x: UIScreen.main.bounds.size.width-182, y: 40, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 844{
            focusRect3 = CGRect.init(x: UIScreen.main.bounds.size.width-180, y: 45, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 926.0{
            focusRect3 = CGRect.init(x: UIScreen.main.bounds.size.width-182, y: 45, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 736.0{
            focusRect3 = CGRect.init(x: UIScreen.main.bounds.size.width-85, y: 20, width:40, height: 44)
        }
        
      let icon1Frame = CGRect(x: self.view.bounds.width/2-72/2, y: (focusRect1.maxY ) + 12, width: 72, height: 72)
      let icon2Frame = CGRect(x: self.view.bounds.width/2-72/2, y: (focusRect1.maxY ) + 12, width: 72, height: 72)
      let icon3Frame = CGRect(x: self.view.bounds.width/2-72/2, y: (focusRect1.maxY ) + 12, width: 72, height: 72)
      let message1 = "Select your suprise occation here"
      let message2 = "Select your suprise for"
      let message3 = "Send a note to your loved ones"
      let message1Center = CGPoint(x: self.view.bounds.width/2, y: icon1Frame.maxY + 24)
      let message2Center = CGPoint(x: self.view.bounds.width/2, y: icon2Frame.maxY + 24)
      let message3Center = CGPoint(x: self.view.bounds.width/2, y: icon3Frame.maxY + 24)
      var tut1 = KJTutorial.textTutorial(focusRectangle: focusRect1 , text: message1, textPosition: message1Center)
        var tut2 = KJTutorial.textTutorial(focusRectangle: focusRect2 , text: message2, textPosition: message2Center)
        var tut3 = KJTutorial.textTutorial(focusRectangle: focusRect3 , text: message3, textPosition: message3Center)
      tut1.isArrowHidden = false
        tut2.isArrowHidden = false
        tut3.isArrowHidden = false
      // tuts
      let tutorials = [tut1,tut2,tut3]
      self.tutorialVC.tutorials = tutorials
      self.tutorialVC.showInViewController(self)
    }
}

extension PickDateAndTimeController: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
    
        
    }
    
}
