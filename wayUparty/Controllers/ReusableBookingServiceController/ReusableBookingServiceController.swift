//
//  ReusableBookingServiceController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 29/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit

class ReusableBookingServiceController: UIViewController {
    @IBOutlet weak var NoProductsImageView: UIView!
    
    @IBOutlet var notAvailableImg: UIImageView!
    var type : String = ""
    var itemsOffered = NSArray()
    var menuItem = NSArray()
    var menuItemUUID = NSArray()
    var menuItemsList = NSArray()
    var getServicesListModel:GetServicesListModel!
    var packageName = String()
    var discountType = Array<String>()
    @IBOutlet weak var tableView:UITableView!
    var vendorId = String()
    var serviceId = Array<String>()
    let imageCache = NSCache<AnyObject, AnyObject>()
    var serviceType = String()
    var supriseName = Array<String>()
    var supriseUUID = Array<String>()
    var occationSupriseName = Array<String>()
    var occationSupriseUUID = Array<String>()
    var dealSubType = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.serviceType)
        
        showSwiftLoader()
        if getServicesListModel.subCategory.count == 0{
            self.hideSwiftLoader()
            self.NoProductsImageView.isHidden = false
            self.notAvailableImg.isHidden = false
           // self.NoProductsImageView.image = UIImage(named: "bottlesout.png")
            self.tableView.separatorStyle = .none
            switch type {
            case "Cheers":
                self.notAvailableImg.image = UIImage.init(named: "bottles_soldout.png")
            case "Save the Seat":
                self.notAvailableImg.image = UIImage.init(named: "no_table.png")
            case "Make a Jump":
                self.notAvailableImg.image = UIImage.init(named: "no_entry.png")
            case "Make It Personal":
                self.notAvailableImg.image = UIImage.init(named: "no_surprise.png")
            case "Deals":
                self.notAvailableImg.image = UIImage.init(named: "no_offers.png")
            case "The WayU Party":
                self.notAvailableImg.image = UIImage.init(named: "no_packages.png")
            case "Events":
                self.notAvailableImg.image = UIImage.init(named: "no_events.png")
            default:
                print("no default")
            }
        }else{self.NoProductsImageView.isHidden =  true
            self.notAvailableImg.isHidden = true
            self.hideSwiftLoader()
        }
        self.supriseName = self.getServicesListModel.surpriseName.first  as? Array<String> ?? Array<String>()
        self.supriseUUID = self.getServicesListModel.surpriseUUID.first as? Array<String> ?? Array<String>()
        self.occationSupriseName = self.getServicesListModel.occationSupriseName.first  as? Array<String> ?? Array<String>()
        self.occationSupriseUUID = self.getServicesListModel.occationSupriseUUID.first  as? Array<String> ?? Array<String>()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backButton = UIBarButtonItem()
        backButton.title = self.dealSubType
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
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

class BookABottleCell:UITableViewCell{
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var timeSlotsLbl: UILabel!
    @IBOutlet weak var guestsAllowedLbl: UILabel!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var offerPrice: UILabel!
    //@IBOutlet weak var currencySymbol: UILabel!
    @IBOutlet weak var cellTitle: UILabel!
}


extension ReusableBookingServiceController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "BookABottleCell") as! BookABottleCell
        let constants = Constants()
        cell.cellTitle.text = getServicesListModel.subCategory[indexPath.row]
        self.imageFromServerURL(URLString: constants.baseUrl+self.getServicesListModel.serviceImage[indexPath.row], placeHolder:UIImage.init(named: "beer.jpg"), imageView: cell.cellImageView)
        cell.cellImageView.layer.cornerRadius = 60
        cell.cellImageView.layer.borderWidth = 2
        cell.cellImageView.layer.borderColor = UIColor.white.cgColor
        cell.guestsAllowedLbl.text = "Guests Allowed - \(getServicesListModel.allowed[indexPath.row])"
        cell.originalPrice.text = "\(getServicesListModel.actualPrice[indexPath.row])"
        cell.timeSlotsLbl.text = "Availability : \(getServicesListModel.startDate[indexPath.row]) to \(getServicesListModel.endDate[indexPath.row])"
        var strikableTxt = NSAttributedString()
        var attributeString = NSMutableAttributedString()
        
        if self.type == "Deals"{
            let discountType = self.discountType[indexPath.row]
            if discountType == "amount"{
                attributeString =  NSMutableAttributedString(string: "On Order of ₹ \(getServicesListModel.actualPrice[indexPath.row]) Save ₹ \(getServicesListModel.offerPrice[indexPath.row])")
                cell.offerPrice.text = "Rs:\(getServicesListModel.actualPrice[indexPath.row] - getServicesListModel.offerPrice[indexPath.row])"
            }else{
                attributeString =  NSMutableAttributedString(string: "On Order of ₹ \(getServicesListModel.actualPrice[indexPath.row]) Save \(getServicesListModel.offerPrice[indexPath.row]) %")
                let value = calculatePercentage(value: getServicesListModel.actualPrice[indexPath.row],percentageVal: getServicesListModel.offerPrice[indexPath.row])
                 print(value)
                cell.offerPrice.text = "Rs:\(getServicesListModel.actualPrice[indexPath.row]-value)"
            }
        }
        else{
            cell.offerPrice.text = "Rs:\(getServicesListModel.offerPrice[indexPath.row])"
            strikableTxt = NSAttributedString.init(attributedString: NSAttributedString.init(string: "₹ \(getServicesListModel.actualPrice[indexPath.row])"))
            attributeString =  NSMutableAttributedString(string: "₹ \(getServicesListModel.actualPrice[indexPath.row]) Save ₹ \(getServicesListModel.actualPrice[indexPath.row]-getServicesListModel.offerPrice[indexPath.row])")
           attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, strikableTxt.length))
           attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.lightGray, range: NSMakeRange(0, attributeString.length))
        }
         
        cell.originalPrice.attributedText = attributeString
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getServicesListModel.subCategory.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String
        if userUUID != nil{
            var pickDateCon = PickDateAndTimeController()
            pickDateCon = self.storyboard?.instantiateViewController(withIdentifier: "PickDateAndTimeController") as! PickDateAndTimeController
            pickDateCon.serviceType = self.serviceType
            var datesArray = Array<String>()
            for i in 0..<(self.getServicesListModel.startTime[indexPath.row] as! Array<String>).count{
                let startTime = self.getServicesListModel.startTime[indexPath.row] as! Array<String>
                let statTIME = startTime[i]
                let endTime = self.getServicesListModel.endTime[indexPath.row] as! Array<String>
                let endTIME = endTime[i]
                let finalTime = statTIME + " to " + endTIME
                datesArray.append(finalTime)
            }
            pickDateCon.guestsAllowed = self.getServicesListModel.allowed[indexPath.row]
            pickDateCon.getServicesListModel = self.getServicesListModel
            pickDateCon.type = self.type
            pickDateCon.timeSlotsArray = datesArray
            pickDateCon.passableDates = self.getServicesListModel.passableDate[indexPath.row] as! [String]
            pickDateCon.datesArray = self.getServicesListModel.serviceDate[indexPath.row] as! [String]
            pickDateCon.imgUrl = self.getServicesListModel.serviceImage[indexPath.row]
            pickDateCon.bottleName = self.getServicesListModel.subCategory[indexPath.row]
            if type == "Deals"{
                let discountType = self.discountType[indexPath.row]
                if discountType != "amount"{
                    let value = calculatePercentage(value: getServicesListModel.actualPrice[indexPath.row],percentageVal: getServicesListModel.offerPrice[indexPath.row])
                     print(value)
                    pickDateCon.price = (getServicesListModel.actualPrice[indexPath.row]-value)
                   
                }
                else{pickDateCon.price = self.getServicesListModel.actualPrice[indexPath.row] - self.getServicesListModel.offerPrice[indexPath.row]}
            }
            else{
                pickDateCon.price = self.getServicesListModel.offerPrice[indexPath.row]
            }
            
            pickDateCon.masterServiceUUID = self.serviceId[indexPath.row]
            pickDateCon.vendorId = self.vendorId
            if serviceType == "The WayU Party"{
                pickDateCon.serviceType = "The WayU Party"
                pickDateCon.itemsOffered = self.itemsOffered[indexPath.row] as! NSArray
                pickDateCon.menuItemUUID = self.menuItemUUID[indexPath.row] as! NSArray
                print(self.menuItem)
                pickDateCon.menuItem = self.menuItem[indexPath.row] as! NSArray
                pickDateCon.menuItemsList = self.menuItemsList[indexPath.row] as! NSArray
                pickDateCon.packageName = self.packageName
            }else if type == "Cheers"{
                
                mlDetailsinfo = self.getServicesListModel.mlDetailsListInfo[indexPath.row] as? NSArray
                
            }
            
            self.navigationController?.pushViewController(pickDateCon, animated: true)
        }
        else{
            var loginCon = LoginController()
            loginCon = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            loginCon.navCon = self.navigationController!
            loginCon.type = self.type
            loginCon.getServicesListModel = self.getServicesListModel
            loginCon.isScreenTypeReusableResCon = true
            loginCon.datesArray = self.getServicesListModel.serviceDate[indexPath.row] as! [String]
            var datesArray = Array<String>()
            for i in 0..<(self.getServicesListModel.startTime[indexPath.row] as! Array<String>).count{
                let startTime = self.getServicesListModel.startTime[indexPath.row] as! Array<String>
                let statTIME = startTime[i]
                let endTime = self.getServicesListModel.endTime[indexPath.row] as! Array<String>
                let endTIME = endTime[i]
                let finalTime = statTIME + " to " + endTIME
                datesArray.append(finalTime)
            }
            loginCon.guestsAllowed = self.getServicesListModel.allowed[indexPath.row]
            loginCon.vendorId = self.vendorId
            loginCon.timeSlotsArray = datesArray
            if self.serviceType == "The WayU Party"{
                loginCon.serviceType = "The WayU Party"
                loginCon.itemsOffered = self.itemsOffered[indexPath.row] as! NSArray
                loginCon.menuItemUUID = self.menuItemUUID[indexPath.row] as! NSArray
                loginCon.menuItem = self.menuItem[indexPath.row] as! NSArray
                loginCon.menuItemsList = self.menuItemsList[indexPath.row] as! NSArray
                loginCon.packageName = self.packageName
            }
            loginCon.passableDates = self.getServicesListModel.passableDate[indexPath.row] as! [String]
            loginCon.imgUrl = self.getServicesListModel.serviceImage[indexPath.row]
            loginCon.masterServiceUUID = self.serviceId[indexPath.row]
            loginCon.price = self.getServicesListModel.offerPrice[indexPath.row]
            loginCon.bottleName = self.getServicesListModel.subCategory[indexPath.row]
            
            self.present(loginCon, animated: true)
        }
        
    }
   
    
    func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value * percentageVal
        return val / 100.0
    }
    
}
