//
//  ViewController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 01/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import CCBottomRefreshControl
import FSPagerView
import ScrollingPageControl
import CoreLocation
import AwaitToast
import MessageUI
import LabelSwitch
import MarqueeLabel
import Mobilisten
import GoogleMaps

class HomeController: UIViewController,CLLocationManagerDelegate, UISearchResultsUpdating,GMSMapViewDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        print("I AM Called")
    }

   // @IBOutlet weak var searchlocationBtn: UIButton!
    
    @IBOutlet weak var noResturentsImageView: UIImageView!
    
    @IBOutlet weak var oopsimgVw: UIImageView!
    
    @IBOutlet weak var noclubsLbl: UILabel!
    @IBOutlet weak var browsBtn: UIButton!
   
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var searchViewHeight: NSLayoutConstraint!
    
//    @IBOutlet var dealsoffersLbl: UILabel!
//
//    @IBOutlet var offersBtn: UIButton!
    
    @IBOutlet weak var dealsView: UIView!
    
    @IBOutlet weak var dealsandOffersCollection: UICollectionView!
    
    @IBOutlet weak var searchcontenVw: UIView!
    
    @IBOutlet weak var topspendLbl: MarqueeLabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var pageControl = ScrollingPageControl()
    var didFindLocation:Bool = false
    let imageCache = NSCache<AnyObject, AnyObject>()
    var refreshControl: UIRefreshControl?
    var minOffset:Int = 0
    var limit:Int = 1000
    var restaurentListModel:RestuarentListModel! = nil
    var filterdataModel:FiltersListModel! = nil
    var topspendList:TopSpendingModel! = nil
    
   
    var timer : Timer?
    var imageNames:Array<String> = []
    var index = Int()
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    var getServicesModel:GetServicesModel!
    var serviceUUID : String = ""
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    
    var resultarr:NSArray!
    var imagestringUrl:Array<String> = []
    var image:Int!
    var dealtype:Array<String> = []
    var searchClubs = [String]()
    var isSearching = false
    let contants = Constants()
    var category_id:Int = 0
    
    
   // @IBOutlet var searchBar: UISearchBar!
    var vendorType = ""
    var locBtn = UIButton()
    var categoryUUIDs = Array<String>()
    var vendorUUID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewfornavBar()
        hideKeyboardWhenTappedAround()
        self.vendorType = "CLUBS"
        setNeedsStatusBarAppearanceUpdate()
        NotificationCenter.default.addObserver(self, selector: #selector(SetYourLocation.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        //self.searchBar.delegate = self
//        self.searchBar.layer.cornerRadius = 10
//        self.searchBar.showsCancelButton = true
//        self.searchBar.layer.borderColor = UIColor.white.cgColor
//        self.searchBar.clipsToBounds = true
        self.browsBtn.layer.cornerRadius = 20
        self.browsBtn.addTarget(self, action: #selector(self.setLocationForRestaurents), for: .touchUpInside)
       
          addLeftBarIcon(named: "logo_Icon")
        registerCollectionCells()
        //self.imageNames = ["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg","7.jpg"]
        DispatchQueue.main.async {
            self.bannerimageLoads()
        }
        
        //setUpNavigationBarItems()
        refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl?.triggerVerticalOffset = 2.0
        refreshControl?.addTarget(self, action: #selector(paginateMore), for: .valueChanged)
        collectionView.bottomRefreshControl = refreshControl
       
        
       
           // 4
           locationManager.delegate = self
           locationManager.startUpdatingLocation()
           rightbarButtonfordeals()
          self.searchViewHeight.constant = 64
        self.searchcontenVw.layer.borderWidth = 0.5
        self.searchcontenVw.layer.borderColor = UIColor.white.cgColor
          
          self.dealsView.isHidden = true
        
        
        
    }
    func registerCollectionCells()  {
        collectionView.register(UINib(nibName: "HomeCollection", bundle: nil), forCellWithReuseIdentifier: "HomeCollection")
        
    }
   
    func bannerimageLoads()  {
        showSwiftLoader()
        let bannerurl = "/ws/getSpecialPackageBannersList"
        let jsonurl = "\(contants.baseUrl + bannerurl)"
                        guard let requesturl = URL(string: jsonurl) else{return
                                                    }
                        let request = URLRequest(url: requesturl)
                        let task = URLSession.shared.dataTask(with: request) {  (data,response,error) in
                            if error != nil {
                                print(error ?? "nil")
                            }
                            else{
                                if let urlcontent = data{
                                    do{
                                        let jsonResult = try JSONSerialization.jsonObject(with: urlcontent, options: .mutableLeaves) as AnyObject
                                        self.hideSwiftLoader()
                                        self.resultarr = (jsonResult as AnyObject).object(forKey: "data") as? NSArray
        
                                       //print("resultarr:\(self.resultarr.count)")
//                                        for i in 0..<self.resultarr.count {
//                                            let details = self.resultarr[i] as? NSDictionary ?? [:]
//                                            let images = details.object(forKey: "eventMobileBannerImage") as! String
//                                            self.imageNames.append(images)
//                                            print("imageindexx:\(self.imageNames)")
//                                        }
                                        DispatchQueue.main.async {
                                            self.collectionView.delegate = self
                                            self.collectionView.dataSource = self
        
                                        }
        
                                             }
                                    catch {
                                        print(" jsonfetching failed")
                                    }
        
                                        }
        
        
                                     }
                        }
                        task.resume()
                   
                   
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        print("city:\(cityname)")
        //self.searchlocationBtn.setTitle("\(cityname)", for: .normal)
    }
    
    @IBAction func mapTapped(_ sender:UIButton){
        if sender.tag == 0{
            //unhide map
            mapView.isHidden = false
            mapView.delegate = self
            let camera = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: 6.0)
                    mapView.camera = camera
                    showMarker(position: camera.target)
            sender.tag = 1
        }else{
            //hide map
            mapView.isHidden = true
            
            sender.tag = 0
        }
    }
    
    func showMarker(position: CLLocationCoordinate2D){
            let marker = GMSMarker()
            marker.position = position
            marker.title = "Palo Alto"
            marker.snippet = "San Francisco"
            marker.map = mapView
        }
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    } 
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            if status == "Offline" {
                let story = UIStoryboard(name: "Main", bundle: nil)
                let neworVc = story.instantiateViewController(withIdentifier: "OfflineController") as! OfflineController
                neworVc.modalPresentationStyle = .fullScreen
                self.present(neworVc, animated: true, completion: nil)
            }
        }
        
    }
    func addLeftBarIcon(named:String) {

        let logoImage = UIImage.init(named: named)
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x:0.0,y:0.0, width:55,height:25.0)
        logoImageView.contentMode = .scaleAspectFill
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 55)
        let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 25)
         heightConstraint.isActive = true
         widthConstraint.isActive = true
         navigationItem.leftBarButtonItem =  imageItem
    }
    
    
    func startTimer()
    {
      if timer == nil {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(navigatingScreens), userInfo: nil, repeats: true)
      }
    }
    func loadingIndicator(){
        isAnimationFalse = false
        var loadingSupport = LoadingSupport()
        loadingSupport = self.storyboard?.instantiateViewController(withIdentifier: "LoadingSupport") as! LoadingSupport
        addChild(loadingSupport)
        self.view.addSubview(loadingSupport.view)
    }
    @objc func navigatingScreens(){
        if tabBarScreen == "cart"{
            self.tabBarController?.selectedIndex = 1
        }
        if tabBarScreen == "orders"{
            self.tabBarController?.selectedIndex = 3
        }
        if tabBarScreen == "home"{
            self.tabBarController?.selectedIndex = 0
        }
        if tabBarScreen == "profile"{
            self.tabBarController?.selectedIndex = 4
        }
        if tabBarScreen == "signOut"{
            self.tabBarController?.selectedIndex = 0
        }
        if tabBarScreen == "events" {
            self.tabBarController?.selectedIndex = 2
        }
    }

    func stopTimer()
    {
      if timer != nil {
        timer!.invalidate()
        timer = nil
      }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.isHidden = false
       // self.searchlocationBtn.addTarget(self, action: #selector(setLocationForRestaurents), for: .touchUpInside)
        self.tabBarController?.tabBar.isHidden = false
       // self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.delegate = self
        ZohoSalesIQ.showLauncher(true)
        
        let customTheme = ZohoSalesIQ.Theme.baseTheme
        customTheme.Launcher.backgroundColor = UIColor.yellow
        customTheme.Launcher.iconColor = UIColor.black
        
        ZohoSalesIQ.Chat.setCustomChatIcon(image: UIImage(named: "SupportChat.png"))
        ZohoSalesIQ.Theme.setTheme(theme: customTheme)
        
        locBtn.setTitle("\(cityname)", for: .normal)
        

        
        startTimer()
        if dealsAndOffersOn == false{
            self.category_id = 0
            
            
            getallrestaurentsList()
            rightbarButtonfordeals()
            dealsView.isHidden = true
        }else{
            dealsView.isHidden = false
        }
       
        topspendingList() 
        
    }
    
    func getallrestaurentsList()  {
        showSwiftLoader()
        if lat != "" && lng != ""{
            minOffset = 0
            let contants = Constants()
            let url = contants.baseUrl + "/ws/getAllregisteredRestaurantsListByRatingByVendorType?latitude=\(lat)&longitude=\(lng)&vendorType=\(self.vendorType)"
            RestuarentListParser.getRestuarentsList(Url: url){(responce) in
                self.hideSwiftLoader()
                self.restaurentListModel = responce.restuarentList.first
                self.minOffset = self.minOffset + 5
                DispatchQueue.main.async {
                   if self.restaurentListModel.vendorName.count == 0{
                    self.noResturentsImageView.isHidden = false
                    self.browsBtn.isHidden = false
                    self.noResturentsImageView.image = UIImage.init(named: "BG_Screen.jpg")
                    self.oopsimgVw.isHidden = false
                    self.noclubsLbl.isHidden = false
                    }else{
                        self.noResturentsImageView.isHidden  = true
                        self.browsBtn.isHidden = true
                        self.oopsimgVw.isHidden = true
                        self.noclubsLbl.isHidden = true
                        
                    }
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
    func clearSerachbar() {
        isSearching = false
//        searchBar.text = nil
//        searchBar.showsCancelButton = false
//        searchBar.resignFirstResponder()
//        searchBar.endEditing(true)
        collectionView.reloadData()
    }
    
    @objc func setLocationForRestaurents(){
      clearSerachbar()
      var chooseLocCon = SelectCountryVC()
        chooseLocCon = self.storyboard?.instantiateViewController(withIdentifier: "SelectCountryVC") as! SelectCountryVC
        chooseLocCon.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(chooseLocCon, animated: true)
    }
    
    @objc func DealsOffersAction(sender:UIBarButtonItem){
        let url = contants.baseUrl + "/ws/getAllregisteredRestaurantsListByRatingByVendorType?latitude=\(lat)&longitude=\(lng)&vendorType=\(self.vendorType)"
        if lat != "" && lng != ""{
            if dealsAndOffersOn == true{
                minOffset = 0
                RestuarentListParser.getRestuarentsList(Url:url){(responce) in
                    self.restaurentListModel = responce.restuarentList.first
                    self.minOffset = self.minOffset + 5
                    dealsAndOffersOn = false
                    DispatchQueue.main.async {
                        if self.restaurentListModel.vendorName.count == 0{
                            self.noResturentsImageView.isHidden = false
                         self.noResturentsImageView.image = UIImage.init(named: "BG_Screen.jpg")
                            self.browsBtn.isHidden = false
                            self.oopsimgVw.isHidden = false
                            self.noclubsLbl.isHidden = false
                         }else{ self.noResturentsImageView.isHidden = true
                            self.browsBtn.isHidden = true
                            self.oopsimgVw.isHidden = true
                            self.noclubsLbl.isHidden = true
                         }
                        let toast = Toast.default(text: "Deals and Offers Filters are Off", direction: .bottom)
                        toast.show()
                        self.collectionView.reloadData()
                    }
                }
            }else{
                minOffset = 0
                
                
                RestuarentListParser.getRestuarentsList(Url:url){(responce) in
                    self.restaurentListModel = responce.restuarentList.first
                    self.minOffset = self.minOffset + 5
                    dealsAndOffersOn = true
                    DispatchQueue.main.async {
                        if self.restaurentListModel.vendorName.count == 0{
                            self.noResturentsImageView.isHidden = false
                         self.noResturentsImageView.image = UIImage.init(named: "BG_Screen.jpg")
                            self.browsBtn.isHidden = false
                            self.browsBtn.layer.cornerRadius = 20
                            self.oopsimgVw.isHidden = false
                            self.noclubsLbl.isHidden = false
                            self.browsBtn.addTarget(self, action: #selector(self.setLocationForRestaurents), for: .touchUpInside)
                         }else{self.noResturentsImageView.isHidden  = true
                            self.browsBtn.isHidden = true
                            self.oopsimgVw.isHidden = true
                            self.noclubsLbl.isHidden = true
                         }
                        let toast = Toast.default(text: "Deals and Offers Filters are On", direction: .bottom)
                        toast.show()
                        self.collectionView.reloadData()
                   }
                }
            }
        }
        else{
            if dealsAndOffersOn == true{
            minOffset = 0
                RestuarentListParser.getRestuarentsList(Url:url){(responce) in
                self.restaurentListModel = responce.restuarentList.first
                self.minOffset = self.minOffset + 5
                dealsAndOffersOn = false
                DispatchQueue.main.async {
                    if self.restaurentListModel.vendorName.count == 0{
                         self.noResturentsImageView.isHidden = false
                     self.noResturentsImageView.image = UIImage.init(named: "BG_Screen.jpg")
                        self.browsBtn.isHidden = false
                        self.browsBtn.layer.cornerRadius = 20
                        self.oopsimgVw.isHidden = false
                        self.noclubsLbl.isHidden = false
                        self.browsBtn.addTarget(self, action: #selector(self.setLocationForRestaurents), for: .touchUpInside)
                     }else{self.noResturentsImageView.isHidden  = true
                        self.browsBtn.isHidden = true
                        self.oopsimgVw.isHidden = true
                        self.noclubsLbl.isHidden = true
                     }
                    let toast = Toast.default(text: "Deals and Offers Filters are Off", direction: .bottom)
                    toast.show()
                    self.collectionView.reloadData()
                }
            }
        }else{
            minOffset = 0
            RestuarentListParser.getRestuarentsList(Url:url){(responce) in
                self.restaurentListModel = responce.restuarentList.first
                self.minOffset = self.minOffset + 5
                dealsAndOffersOn = true
                DispatchQueue.main.async {
                    if self.restaurentListModel.vendorName.count == 0{
                         self.noResturentsImageView.isHidden = false
                     self.noResturentsImageView.image = UIImage.init(named: "BG_Screen.jpg")
                        self.browsBtn.isHidden = false
                        self.browsBtn.layer.cornerRadius = 20
                        self.oopsimgVw.isHidden = false
                        self.noclubsLbl.isHidden = false
                        self.browsBtn.addTarget(self, action: #selector(self.setLocationForRestaurents), for: .touchUpInside)
                     }else{self.noResturentsImageView.isHidden  = true
                        self.browsBtn.isHidden = true
                        self.oopsimgVw.isHidden = true
                        self.noclubsLbl.isHidden = true
                     }
                    let toast = Toast.default(text: "Deals and Offers Filters are On", direction: .bottom)
                    toast.show()
                    self.collectionView.reloadData()
               }
            }
         }
      }
   }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            currentLocation = locValue
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            locationManager.stopUpdatingLocation()
            manager.delegate = nil
        let url = contants.baseUrl + "/ws/getAllregisteredRestaurantsListByRatingByVendorType?latitude=\(lat)&longitude=\(lng)&vendorType=\(self.vendorType)"
        RestuarentListParser.getRestuarentsList(Url:url){(responce) in
            self.restaurentListModel = responce.restuarentList.first
            self.minOffset = self.minOffset + 5
            DispatchQueue.main.async {
               if self.restaurentListModel.vendorName.count == 0{
                self.noResturentsImageView.isHidden = false
                self.noResturentsImageView.image = UIImage.init(named: "BG_Screen.jpg")
                self.browsBtn.isHidden = false
                self.browsBtn.layer.cornerRadius = 20
                self.oopsimgVw.isHidden = false
                self.noclubsLbl.isHidden = false
                self.browsBtn.addTarget(self, action: #selector(self.setLocationForRestaurents), for: .touchUpInside)
                }else{self.noResturentsImageView.isHidden  = true
                    self.browsBtn.isHidden = true
                    self.oopsimgVw.isHidden = true
                    self.noclubsLbl.isHidden = true
                }
                self.collectionView.reloadData()
            }
        }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
   

    @objc func paginateMore(){
        let url = contants.baseUrl + "/ws/getAllregisteredRestaurantsListByRatingByVendorType?latitude=\(lat)&longitude=\(lng)&vendorType=\(self.vendorType)"
        if dealsAndOffersOn == false{
            
            if lat != "" && lng != ""{
                RestuarentListParser.getRestuarentsList(Url:url){(responce) in
                    let vendorName = responce.restuarentList.first?.vendorName
                    let vendorEmail = responce.restuarentList.first?.vendorEmail
                    let vendorMobile = responce.restuarentList.first?.vendorMobile
                    let vendorCode = responce.restuarentList.first?.vendorCode
                    let location = responce.restuarentList.first?.location
                    let bestSellingItems = responce.restuarentList.first?.vendorName
                    let vendorProfileImg = responce.restuarentList.first?.vendorProfileImg
                    let vendorUUID = responce.restuarentList.first?.vendorUUID
                    let costForTwoPeople = self.restaurentListModel.costForTwoPeople
                    let kilometers = self.restaurentListModel.kilometers
                    if vendorName?.count == 0{
                        DispatchQueue.main.async {
                            self.refreshControl = nil
                            self.collectionView.bottomRefreshControl = nil
                        }
                    }else{
                        for i in 0..<vendorName!.count{
                            self.restaurentListModel.vendorName.append(vendorName![i])
                            self.restaurentListModel.vendorEmail.append(vendorEmail![i])
                            self.restaurentListModel.vendorMobile.append(vendorMobile![i])
                            self.restaurentListModel.vendorCode.append(vendorCode![i])
                            self.restaurentListModel.location.append(location![i])
                            self.restaurentListModel.bestSellingItems.append(bestSellingItems![i])
                            self.restaurentListModel.vendorProfileImg.append(vendorProfileImg![i])
                            self.restaurentListModel.vendorUUID.append(vendorUUID![i])
                            self.restaurentListModel.costForTwoPeople.append(costForTwoPeople[i])
                            self.restaurentListModel.kilometers.append(kilometers[i])
                        }
                        DispatchQueue.main.async {
                            self.minOffset = self.minOffset + 5
                            self.refreshControl?.isHidden = true
                            self.collectionView.reloadData()
                            self.refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                            self.refreshControl?.triggerVerticalOffset = 10.0
                            if vendorName?.count ?? 0 > 15{
                                self.refreshControl?.addTarget(self, action: #selector(self.paginateMore), for: .valueChanged)
                                self.collectionView.bottomRefreshControl = self.refreshControl
                            }else{
                                self.refreshControl = nil
                                self.collectionView.bottomRefreshControl = nil
                            }
                            
                        }
                    }
                }
            }
            else{
                let Url = contants.baseUrl + "/ws/getAllregisteredRestaurantsListByRatingByVendorType?latitude=\(currentLocation.latitude)&longitude=\(currentLocation.longitude)&vendorType=\(self.vendorType)"
                RestuarentListParser.getRestuarentsList(Url:Url){(responce) in
                    let vendorName = responce.restuarentList.first?.vendorName
                    let vendorEmail = responce.restuarentList.first?.vendorEmail
                    let vendorMobile = responce.restuarentList.first?.vendorMobile
                    let vendorCode = responce.restuarentList.first?.vendorCode
                    let location = responce.restuarentList.first?.location
                    let bestSellingItems = responce.restuarentList.first?.vendorName
                    let vendorProfileImg = responce.restuarentList.first?.vendorProfileImg
                    let vendorUUID = responce.restuarentList.first?.vendorUUID
                    let costForTwoPeople = self.restaurentListModel.costForTwoPeople
                    let kilometers = self.restaurentListModel.kilometers
                    if vendorName?.count == 0{
                        DispatchQueue.main.async {
                            self.refreshControl = nil
                            self.collectionView.bottomRefreshControl = nil
                        }
                    }else{
                        for i in 0..<vendorName!.count{
                            self.restaurentListModel.vendorName.append(vendorName![i])
                            self.restaurentListModel.vendorEmail.append(vendorEmail![i])
                            self.restaurentListModel.vendorMobile.append(vendorMobile![i])
                            self.restaurentListModel.vendorCode.append(vendorCode![i])
                            self.restaurentListModel.location.append(location![i])
                            self.restaurentListModel.bestSellingItems.append(bestSellingItems![i])
                            self.restaurentListModel.vendorProfileImg.append(vendorProfileImg![i])
                            self.restaurentListModel.vendorUUID.append(vendorUUID![i])
                            self.restaurentListModel.costForTwoPeople.append(costForTwoPeople[i])
                            self.restaurentListModel.kilometers.append(kilometers[i])
                        }
                        DispatchQueue.main.async {
                            self.minOffset = self.minOffset + 5
                            self.refreshControl?.isHidden = true
                            self.collectionView.reloadData()
                            self.refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                            self.refreshControl?.triggerVerticalOffset = 10.0
                            if vendorName?.count ?? 0 > 15{
                                self.refreshControl?.addTarget(self, action: #selector(self.paginateMore), for: .valueChanged)
                                self.collectionView.bottomRefreshControl = self.refreshControl
                            }else{
                                self.refreshControl = nil
                                self.collectionView.bottomRefreshControl = nil
                            }
                            
                        }
                    }
                }
            }
        }else{
            let Url = contants.baseUrl + "/ws/getAllregisteredRestaurantsListByRating?latitude=\(lat)&longitude=\(lng)&deals=Y&categoryId="
            if lat != "" && lng != ""{
                RestuarentListParser.getRestuarentsList(Url:Url){(responce) in
                    let vendorName = responce.restuarentList.first?.vendorName
                    let vendorEmail = responce.restuarentList.first?.vendorEmail
                    let vendorMobile = responce.restuarentList.first?.vendorMobile
                    let vendorCode = responce.restuarentList.first?.vendorCode
                    let location = responce.restuarentList.first?.location
                    let bestSellingItems = responce.restuarentList.first?.vendorName
                    let vendorProfileImg = responce.restuarentList.first?.vendorProfileImg
                    let vendorUUID = responce.restuarentList.first?.vendorUUID
                    let costForTwoPeople = self.restaurentListModel.costForTwoPeople
                    let kilometers = self.restaurentListModel.kilometers
                    if vendorName?.count == 0{
                        DispatchQueue.main.async {
                            self.refreshControl = nil
                            self.collectionView.bottomRefreshControl = nil
                        }
                    }else{
                        for i in 0..<vendorName!.count{
                            self.restaurentListModel.vendorName.append(vendorName![i])
                            self.restaurentListModel.vendorEmail.append(vendorEmail![i])
                            self.restaurentListModel.vendorMobile.append(vendorMobile![i])
                            self.restaurentListModel.vendorCode.append(vendorCode![i])
                            self.restaurentListModel.location.append(location![i])
                            self.restaurentListModel.bestSellingItems.append(bestSellingItems![i])
                            self.restaurentListModel.vendorProfileImg.append(vendorProfileImg![i])
                            self.restaurentListModel.vendorUUID.append(vendorUUID![i])
                            self.restaurentListModel.costForTwoPeople.append(costForTwoPeople[i])
                            self.restaurentListModel.kilometers.append(kilometers[i])
                        }
                        DispatchQueue.main.async {
                            self.minOffset = self.minOffset + 5
                            self.refreshControl?.isHidden = true
                            self.collectionView.reloadData()
                            self.refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                            self.refreshControl?.triggerVerticalOffset = 10.0
                            if vendorName?.count ?? 0 > 15{
                                self.refreshControl?.addTarget(self, action: #selector(self.paginateMore), for: .valueChanged)
                                self.collectionView.bottomRefreshControl = self.refreshControl
                            }else{
                                self.refreshControl = nil
                                self.collectionView.bottomRefreshControl = nil
                            }
                            
                        }
                    }
                }
            }
            else{
                let Url = contants.baseUrl + "/ws/getAllregisteredRestaurantsListByRating?latitude=\(currentLocation.latitude)&longitude=\(currentLocation.longitude)&deals=Y&categoryId="
             
                RestuarentListParser.getRestuarentsList(Url:Url){(responce) in
                    let vendorName = responce.restuarentList.first?.vendorName
                    let vendorEmail = responce.restuarentList.first?.vendorEmail
                    let vendorMobile = responce.restuarentList.first?.vendorMobile
                    let vendorCode = responce.restuarentList.first?.vendorCode
                    let location = responce.restuarentList.first?.location
                    let bestSellingItems = responce.restuarentList.first?.vendorName
                    let vendorProfileImg = responce.restuarentList.first?.vendorProfileImg
                    let vendorUUID = responce.restuarentList.first?.vendorUUID
                    let costForTwoPeople = self.restaurentListModel.costForTwoPeople
                    let kilometers = self.restaurentListModel.kilometers
                    if vendorName?.count == 0{
                        DispatchQueue.main.async {
                            self.refreshControl = nil
                            self.collectionView.bottomRefreshControl = nil
                        }
                    }else{
                        for i in 0..<vendorName!.count{
                            self.restaurentListModel.vendorName.append(vendorName![i])
                            self.restaurentListModel.vendorEmail.append(vendorEmail![i])
                            self.restaurentListModel.vendorMobile.append(vendorMobile![i])
                            self.restaurentListModel.vendorCode.append(vendorCode![i])
                            self.restaurentListModel.location.append(location![i])
                            self.restaurentListModel.bestSellingItems.append(bestSellingItems![i])
                            self.restaurentListModel.vendorProfileImg.append(vendorProfileImg![i])
                            self.restaurentListModel.vendorUUID.append(vendorUUID![i])
                            self.restaurentListModel.costForTwoPeople.append(costForTwoPeople[i])
                            self.restaurentListModel.kilometers.append(kilometers[i])
                        }
                        DispatchQueue.main.async {
                            self.minOffset = self.minOffset + 5
                            self.refreshControl?.isHidden = true
                            self.collectionView.reloadData()
                            self.refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                            self.refreshControl?.triggerVerticalOffset = 10.0
                            if vendorName?.count ?? 0 > 15{
                                self.refreshControl?.addTarget(self, action: #selector(self.paginateMore), for: .valueChanged)
                                self.collectionView.bottomRefreshControl = self.refreshControl
                            }else{
                                self.refreshControl = nil
                                self.collectionView.bottomRefreshControl = nil
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
   

    
    @objc func navigateExploreer(_sender: UIButton){
//        var exploreResCon = ExploreRestuarentController()
//        exploreResCon = self.storyboard?.instantiateViewController(withIdentifier: "ExploreRestuarentController") as! ExploreRestuarentController
//        exploreResCon.restaurentListModel = self.restaurentListModel
//        exploreResCon.intForRestaurent = _sender.tag
//        exploreResCon.restuarentUUID = self.restaurentListModel.vendorUUID[_sender.tag]
//        print(self.restaurentListModel.vendorUUID[_sender.tag])
//        exploreResCon.restuarentName = self.restaurentListModel.vendorName[_sender.tag]
        var exploreResCon = EventsOfClub()
        exploreResCon = self.storyboard?.instantiateViewController(withIdentifier: "EventsOfClub") as! EventsOfClub
        //exploreResCon.isfromHome = true
        exploreResCon.modelDict = self.restaurentListModel.data[_sender.tag] as! [String : Any]
        self.navigationController?.pushViewController(exploreResCon, animated: false)
        
    }
    @objc func navigateToServices(_ sender: UIButton){
        var servicesCon = ServicesController()
        servicesCon = self.storyboard?.instantiateViewController(identifier: "ServicesController") as! ServicesController
        
        servicesCon.vendorUUID = self.restaurentListModel.vendorUUID[sender.tag]
        self.navigationController?.pushViewController(servicesCon, animated: true)
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
                            let imageData = downloadedImage.jpegData(compressionQuality: 0.20)
                            imageViews.image = UIImage(data: imageData!)
                        }
                    }
                }
            }).resume()
        }
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
       
        getallrestaurentsList()
    }
    
    @IBAction func chatAction(_ sender: Any) {
        //Freshchat.sharedInstance().showConversations(self)
    }
    
    
    
    
    func dealsSwitchOn()  {
        showSwiftLoader()
        FilterListParser.getFilterList(serviceid: "serviceID=6"){(response) in
            self.hideSwiftLoader()
            DispatchQueue.main.async {
                self.filterdataModel = response.filterList.first
                self.dealsandOffersCollection.delegate = self
                self.dealsandOffersCollection.dataSource = self
                self.dealsandOffersCollection.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    let selectedIndexpath = IndexPath(row: 0, section: 0)
                    guard let celltodeSelect:DealsandOffersCell = self.dealsandOffersCollection.cellForItem(at: selectedIndexpath) as? DealsandOffersCell else{return}
                    celltodeSelect.contView.backgroundColor = celltodeSelect.backColor
                    celltodeSelect.discountLbl.textColor = UIColor.black
                }
            }
            
        }
    }
    
    
//    func dealsandoffersOn(){
//        if lat != "" && lng != ""{
//            minOffset = 0
//
//            var url = ""
//            if self.category_id == 0{
//                url = contants.baseUrl + "/ws/getAllregisteredRestaurantsListByRating?latitude=\(lat)&longitude=\(lng)&deals=Y&categoryId="
//            }else{
//                url = contants.baseUrl + "/ws/getAllregisteredRestaurantsListByRating?latitude=\(lat)&longitude=\(lng)&deals=Y&categoryId=\(self.category_id)"
//            }
//            RestuarentListParser.getRestuarentsList(Url: url){(responce) in
//                self.restaurentListModel = responce.restuarentList.first
//                self.minOffset = self.minOffset + 5
//                DispatchQueue.main.async {
//                   if self.restaurentListModel.vendorName.count == 0{
//                    self.noResturentsImageView.isHidden = false
//                    self.browsBtn.isHidden = false
//                    self.noResturentsImageView.image = UIImage.init(named: "BG_Screen.jpg")
//                    self.oopsimgVw.isHidden = false
//                    self.noclubsLbl.isHidden = false
//                    }else{
//                        self.noResturentsImageView.isHidden  = true
//                        self.browsBtn.isHidden = true
//                        self.oopsimgVw.isHidden = true
//                        self.noclubsLbl.isHidden = true
//
//                    }
//
//                    self.collectionView.reloadData()
//                }
//            }
//        }
//    }
    func searchScreenNavgation()  {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = story.instantiateViewController(withIdentifier: "NewSearchController") as! NewSearchController
        searchVC.isfromDeals = false
        self.navigationController?.pushViewController(searchVC, animated: true)
        
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
        searchScreenNavgation()
    }
    
    
}

extension HomeController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == dealsandOffersCollection{
            return 1
        }else{
            return 2
        }
      
       
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dealsandOffersCollection{
            return self.filterdataModel.categoryName.count
            
        }else{
            if section == 0{
                if resultarr.count != 0 {
                    return 1
                }
                else {
                    return 0
                }
                
            }
        
             if section == 1  {
                if self.restaurentListModel != nil{
                    if isSearching {
                                 return searchClubs.count
                             } else {
                                return self.restaurentListModel.data.count}
                             }
                
             }
               
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == dealsandOffersCollection{
            let cell = dealsandOffersCollection.dequeueReusableCell(withReuseIdentifier: "DealsandOffersCell", for: indexPath) as! DealsandOffersCell
            let discount = self.filterdataModel.categoryName[indexPath.item]
            
            cell.discountLbl.text = discount
            return cell
            
            
        }else{
            if indexPath.section == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PagerViewCell", for: indexPath) as! PagerViewCell
                cell.pagerView?.delegate = self
                cell.pagerView?.dataSource = self
                self.pageControl.pages = self.resultarr.count
                self.pageControl.selectedColor = UIColor.yellow
                self.pageControl.dotColor = UIColor.white
                self.pageControl.dotSize = 10
                self.pageControl.spacing = 8
                cell.typeIndex = 0
                self.pageControl = cell.pageControl
                cell.shawdowvIEW.layer.cornerRadius = 20
                cell.shawdowvIEW.layer.masksToBounds = true
                cell.backgroundColor = .clear

               
                return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollection", for: indexPath) as! HomeCollection
                if self.restaurentListModel != nil{
                    
                    if isSearching {
                        let constants = Constants()
                        
                        self.imageFromServerURL(URLString: "\(constants.baseUrl+self.restaurentListModel.vendorProfileImg[indexPath.item])", placeHolder: UIImage.init(named: "vimage.jpeg"), imageView: cell.resImageView)
                        cell.restaurentTitle.text = searchClubs[indexPath.item]
                        cell.restuarentLocation.text = self.restaurentListModel.location[indexPath.item]
                       
                        cell.servicelbl.text = self.restaurentListModel.bestSellingItems[indexPath.item]
                        
                    }
                    else{
                    let constants = Constants()
                    
                    self.imageFromServerURL(URLString: "\(constants.baseUrl+self.restaurentListModel.vendorProfileImg[indexPath.item])", placeHolder: UIImage.init(named: "vimage.jpeg"), imageView: cell.resImageView)
                    cell.restaurentTitle.text = self.restaurentListModel.vendorName[indexPath.item]
                    cell.restuarentLocation.text = self.restaurentListModel.location[indexPath.item]
                    cell.servicelbl.text = self.restaurentListModel.bestSellingItems[indexPath.item]
                   // print("Listdatacount:\(self.restaurentListModel.data.count)")
                    }
    //                cell.restaurentCostforPeople.text = "Cost for two Rs.\(self.restaurentListModel.costForTwoPeople[indexPath.item])"
    //                cell.kilometersLbl.text =  "\(self.restaurentListModel.kilometers[indexPath.item]) kilometers from your current location"
                }
                cell.servicesIconBtn.tag = indexPath.item
                cell.servicesTextBtn.tag = indexPath.item
                cell.resImageView.tag = indexPath.item
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigatetoClubInfo))
                cell.resImageView.isUserInteractionEnabled = true
                cell.resImageView.addGestureRecognizer(tapGestureRecognizer)
                
                cell.servicesVw.layer.masksToBounds = true
                cell.servicesVw.layer.cornerRadius = 10
                if vendorType == "CLUBS" {
                    cell.servicesIconBtn.addTarget(self, action: #selector(navigateExploreer(_sender:)), for: .touchUpInside)
                    cell.servicesTextBtn.addTarget(self, action: #selector(navigateToServices), for: .touchUpInside)
                }
                else{
                    cell.servicesIconBtn.addTarget(self, action: #selector(navigateExploreer(_sender:)), for: .touchUpInside)
                    
                }
                
                
                return cell
            }
        }
//        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == dealsandOffersCollection{
            return UIEdgeInsets.init(top: 30, left: 10, bottom: 30, right: 10)
        }else{
            if section == 0{ return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)}
            else{
                return UIEdgeInsets.init(top: 10, left: 5, bottom: 5, right: 10)
            }
        }
//        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == dealsandOffersCollection{
            return 0
        }
        if section == 1{
            return 5
        }
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == dealsandOffersCollection{
            return 15
        }
        if section == 1{
            return 5
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dealsandOffersCollection{
            let width = (self.collectionView.frame.size.width - 90) / 2.0
            return CGSize(width: width, height:44)
        }else{
            if indexPath.section == 0{
           return CGSize(width: 374, height: 120)
            }
            else
           {
           
            
            let width = (view.frame.width - 60) / 2.0

            return CGSize(width: width, height: 296)}
        }
//       return CGSize(width: 0, height: 0)
        
    }
    func columnWidth(for collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> CGFloat
    
       {
           if collectionView == dealsandOffersCollection{
               
               return self.collectionView.frame.size.width / 2 - 250
           }else{
               return self.collectionView.frame.size.width / 2 - 40
           }
        
//           return 0
       }

   func maximumNumberOfColumns(for collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> Int {
                   let numColumns: Int = Int(2.0)
                   return numColumns
           }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // if dealsAndOffersOn == false {
        
           if collectionView == self.dealsandOffersCollection{
               guard let celltodeSelect:DealsandOffersCell = self.dealsandOffersCollection.cellForItem(at: indexPath) as? DealsandOffersCell else{return}
               celltodeSelect.contView.backgroundColor = celltodeSelect.backColor
               celltodeSelect.discountLbl.textColor = UIColor.black
               let story = UIStoryboard(name: "Main", bundle: nil)
               let searchVC = story.instantiateViewController(withIdentifier: "NewSearchController") as! NewSearchController
               searchVC.isfromDeals = true
               searchVC.category_uuid = self.filterdataModel.categoryUUID[indexPath.item]
               searchVC.categ_id = self.filterdataModel.categoryId[indexPath.item]
               searchVC.selectedDeal = self.filterdataModel.categoryName[indexPath.item]
              
               self.navigationController?.pushViewController(searchVC, animated: true)
           }else{
               
           }
            

        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == dealsandOffersCollection{
            let cell = dealsandOffersCollection.dequeueReusableCell(withReuseIdentifier: "DealsandOffersCell", for: indexPath) as! DealsandOffersCell
            
            guard let celltodeSelect:DealsandOffersCell = self.dealsandOffersCollection.cellForItem(at: indexPath) as? DealsandOffersCell else{return}
            if cell.isSelected == true{
                cell.isSelected = false
                celltodeSelect.contView.backgroundColor = UIColor.clear
                celltodeSelect.discountLbl.textColor = UIColor.white
            }else{
                cell.isSelected = false
                celltodeSelect.contView.backgroundColor = UIColor.clear
                celltodeSelect.discountLbl.textColor = UIColor.white
            }
        }
        
        
    }
    
//    @objc func navigatetoEvents(){
//        var eventsCon = ClubEventsController()
//        eventsCon = self.storyboard?.instantiateViewController(withIdentifier: "ClubEventsController") as! ClubEventsController
//        eventsCon.vendorUUID = self.restaurentListModel.vendorUUID[indexPath.item]
//        self.navigationController?.pushViewController(eventsCon, animated: true)
//    }
}

class PagerViewCell:UICollectionViewCell{
    @IBOutlet weak var shawdowvIEW: UIView!
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.depth]
    fileprivate var typeIndex = 0 {
        didSet {
            let type = self.transformerTypes[typeIndex]
            self.pagerView?.transformer = FSPagerViewTransformer(type:type)
            switch type {
            case .depth:
                self.pagerView?.itemSize = FSPagerView.automaticSize
                self.pagerView?.decelerationDistance = 1
            default:
                print("Training on wheels Protocol")
            }
            
        }
        
    }
    @IBOutlet weak var pageControl: ScrollingPageControl!
    @IBOutlet weak var pagerView:FSPagerView?{
        didSet {
            self.pagerView?.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.typeIndex = 0
        }
    }
   
    override func awakeFromNib() {
    super.awakeFromNib()
    
}
 
}
extension HomeController:FSPagerViewDataSource,FSPagerViewDelegate{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if resultarr.count != 0 {
            return resultarr.count
        }else{
            return 0
        }
         
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let constants = Constants()
        
        
       // let baseurl = "https://www.alchohome.com"
        let imageUrl = (self.resultarr[index] as AnyObject).object(forKey: "eventMobileBannerImage") as? String ?? ""
        cell.imageView?.layer.cornerRadius = 20
        cell.imageView?.layer.masksToBounds = true
        if imageUrl != "" {
            self.imageFromServerURL(URLString: "\(constants.baseUrl+imageUrl)", placeHolder: UIImage.init(named: "vimage.jpeg"), imageView: cell.imageView!)
        }else{
            cell.imageView?.image = UIImage(named: "Landing_Page_Web.jpg")
        }
       
        
        return cell
    }
    
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        let type = (self.resultarr[index] as AnyObject).object(forKey: "serviceType") as! String
        let vendorUUID = (self.resultarr[index] as AnyObject).object(forKey: "vendorUUID") as! String
        print("typers:\(vendorUUID)")
        print("typers:\(type)")
        if type == "events" {
            var eventsCon = EventsController()
            eventsCon = self.storyboard?.instantiateViewController(withIdentifier: "EventsController") as! EventsController
            eventsCon.vendorUUID = vendorUUID
            self.navigationController?.pushViewController(eventsCon, animated: true)
            return
        }
        if type == "deals" {
            var servicesCon = ServicesController()
            servicesCon = self.storyboard?.instantiateViewController(identifier: "ServicesController") as! ServicesController
            servicesCon.vendorUUID = vendorUUID
            self.navigationController?.pushViewController(servicesCon, animated: true)
        }

    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.selectedPage = targetIndex
    }
    
}
extension HomeController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchClubs = (self.restaurentListModel.vendorName).filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        isSearching = true
        collectionView.reloadData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
             isSearching = false
             searchBar.text = nil
             searchBar.showsCancelButton = false
             searchBar.resignFirstResponder()
             searchBar.endEditing(true)
             collectionView.reloadData()
         }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}



extension HomeController{
    func contentViewfornavBar()  {
        let contentView = UIView(frame: CGRect(x: 40, y: 0, width:self.view.frame.width-20, height: 40))
        self.navigationItem.titleView = contentView
        contentView.backgroundColor = UIColor.black
        let locLbl = UILabel(frame: CGRect(x: -5, y: 15, width: 50, height: 15))
        contentView.addSubview(locLbl)
        locLbl.font = UIFont.systemFont(ofSize: 9.5)
        locLbl.text = "Location"
        locLbl.textColor = UIColor.white
        locBtn = UIButton(frame: CGRect(x:40, y: 12, width:160 , height: 20))
        contentView.addSubview(locBtn)
        locBtn.setTitle("\(cityname)", for: .normal)
        locBtn.contentHorizontalAlignment = .left
        
        locBtn.setImage(UIImage(named: "locate.png"), for: .normal)
        locBtn.imageEdgeInsets = UIEdgeInsets(top: 3, left: 1, bottom: 3, right: 140)
        locBtn.semanticContentAttribute = .forceLeftToRight
        locBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        locBtn.layer.cornerRadius = 10
        locBtn.layer.borderWidth = 0.6
        locBtn.layer.borderColor = UIColor.white.cgColor
        locBtn.addTarget(self, action: #selector(setLocationForRestaurents), for: .touchUpInside)
        
        
    }
    func rightbarButtonfordeals(){
        let rightVie = UIView(frame: CGRect(x: -5, y: 0, width: 80, height: 40))
        rightVie.backgroundColor = UIColor.clear
        let rightBarButton = UIBarButtonItem(customView: rightVie)
        self.navigationItem.rightBarButtonItem = rightBarButton
        let dealsLbl = UILabel(frame: CGRect(x: 5, y: 0, width: rightVie.frame.size.width, height: 15))
        rightVie.addSubview(dealsLbl)
        dealsLbl.text = "Deals and offers"
        dealsLbl.font = UIFont.systemFont(ofSize: 9.5)
        dealsLbl.textColor = UIColor.white
        let custColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 0.2)
        
        let ls = LabelSwitchConfig(text: "On",
                              textColor: .white,
                                   font: UIFont.boldSystemFont(ofSize: 15),
                        backgroundColor: custColor)
                
        let rs = LabelSwitchConfig(text: "Off",
                              textColor: .white,
                                   font: UIFont.boldSystemFont(ofSize: 15),
                        backgroundColor: custColor)

       
        var labelSwitch = LabelSwitch(frame: CGRect(x: 20, y: 14, width: 40, height: 25))
        labelSwitch = LabelSwitch(center: .init(x: 40, y: 30), leftConfig: ls, rightConfig: rs)
        labelSwitch.layer.masksToBounds = true
        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51
        let heightRatio = 25 / standardHeight
        let widthRatio = 40 / standardWidth
        labelSwitch.transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
        rightVie.addSubview(labelSwitch)
        labelSwitch.circleShadow = false
        labelSwitch.circleColor = UIColor(red: 243/255, green: 194/255, blue: 69/255, alpha: 1)
        labelSwitch.fullSizeTapEnabled = true
        labelSwitch.delegate = self

        
        
        
        


    }
}

extension HomeController: LabelSwitchDelegate {
    func switchChangToState(sender: LabelSwitch) {
        switch sender.curState {
            case .L:
            print("left state off")
            
            dealsandOffersCollection.isHidden = true
            dealsandOffersCollection.delegate = nil
            dealsandOffersCollection.dataSource = nil
            getallrestaurentsList()
            dealsAndOffersOn = false
            self.category_id = 0
            self.dealsView.isHidden = true
            case .R:
            print("right state on")
            
            dealsandOffersCollection.register(UINib(nibName: "DealsandOffersCell", bundle: nil), forCellWithReuseIdentifier: "DealsandOffersCell")
            dealsandOffersCollection.isHidden = false
            dealsandOffersCollection.delegate = self
            dealsandOffersCollection.dataSource = self
            
            dealsSwitchOn()
            dealsAndOffersOn = true
            self.dealsView.isHidden = false
        }
    }
}


extension HomeController:UITabBarControllerDelegate{
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

                let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
                if selectedIndex == 0 {
                    self.viewWillAppear(true)
                } else {
                    
                }
            }
}


extension HomeController{
    func topspendingList()  {
        self.topspendLbl.isHidden = true
        TopSpendParser.getFilterList{(response) in
           
            self.topspendList = response.topspendList.first
            print("spendingList:--->\(String(describing: self.topspendList))")
            //let arraList = self.topspendList.cityName
           // let str = arraList.joined(separator: ", ")
            DispatchQueue.main.async {
                self.topspendLbl.type = .continuous
                self.topspendLbl.speed = .rate(25)
                self.topspendLbl.fadeLength = 10.0
                self.topspendLbl.leadingBuffer = 10.0
                self.topspendLbl.trailingBuffer = 10.0
                //self.topspendLbl.text = str
            }
            
        }
        
    }
}

extension HomeController{
    @objc  func navigatetoClubInfo(_ sender: UITapGestureRecognizer)
    {
        guard let tag = sender.view?.tag else {
            return}
        if self.vendorType == "CLUBS" {
            var servicesCon = ServicesController()
            servicesCon = self.storyboard?.instantiateViewController(identifier: "ServicesController") as! ServicesController
            servicesCon.vendorUUID = self.restaurentListModel.vendorUUID[tag]
            self.navigationController?.pushViewController(servicesCon, animated: true)
        }
        else{
            var eventsCon = ClubEventsController()
            eventsCon = self.storyboard?.instantiateViewController(withIdentifier: "ClubEventsController") as! ClubEventsController
            eventsCon.vendorUUID = self.restaurentListModel.vendorUUID[tag]
            self.navigationController?.pushViewController(eventsCon, animated: true)
            
        }
        
    }
}
