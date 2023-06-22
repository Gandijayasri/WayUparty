//
//  EventsView.swift
//  wayUparty
//
//  Created by Arun on 12/11/21.
//
//

import UIKit
import CCBottomRefreshControl
import FSPagerView
import ScrollingPageControl
import CoreLocation
import AwaitToast
import MessageUI
import MarqueeLabel
class EventsView: UIViewController,CLLocationManagerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("I AM Called")
    }
  
    
    @IBOutlet weak var browsBtn: UIButton!
   
    @IBOutlet weak var noeventsView: UIView!
    
    
    
    
    
    @IBOutlet var eventsList: UITableView!
    var pageControl = ScrollingPageControl()
    var didFindLocation:Bool = false
    let imageCache = NSCache<AnyObject, AnyObject>()
    var refreshControl: UIRefreshControl?
    var minOffset:Int = 0
    var limit:Int = 1000
    var restaurentListModel:RestuarentListModel! = nil
    var topspendList:TopSpendingModel! = nil
   
    @IBOutlet weak var topspendLbl: MarqueeLabel!
    var timer : Timer?
    var imageNames:Array<String> = []
    var index = Int()
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    var getServicesModel:GetServicesModel!
    var serviceUUID : String = ""
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    var dealsAndOffersOn:Bool = false
    var resultarr:NSArray!
    var imagestringUrl:Array<String> = []
    var image:Int!
    var dealtype:Array<String> = []
    var searchClubs = [String]()
    var isSearching = false
    
   
    var vendorType = ""
    let constants = Constants()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.vendorType = "EVENTS"
        setNeedsStatusBarAppearanceUpdate()
        NotificationCenter.default.addObserver(self, selector: #selector(SetYourLocation.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
        self.browsBtn.layer.cornerRadius = 20
        self.browsBtn.addTarget(self, action: #selector(self.setLocationForRestaurents), for: .touchUpInside)
       // collectionView.register(UINib(nibName: "HomeCollection", bundle: nil), forCellWithReuseIdentifier: "HomeCollection")
        
        
        addLeftBarbtnIcon(named: "logo_Icon")
        //self.imageNames = ["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg","7.jpg"]
        
        //setUpNavigationBarItems()
        refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl?.triggerVerticalOffset = 2.0
        refreshControl?.addTarget(self, action: #selector(paginateMore), for: .valueChanged)
        eventsList.bottomRefreshControl = refreshControl
        print(self.minOffset)
        print(self.limit)
       //
        
       
           // 4
           locationManager.delegate = self
           locationManager.startUpdatingLocation()
        
        registerNibs()
        
    }
    
    func registerNibs()  {
       
        eventsList.register(UINib(nibName: "EventsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventsTableViewCell")
        
    }
    
   
    func bannerimageLoads()  {
        let constants = Constants()
        let bannerurl = "/ws/getSpecialPackageBannersList"
        let jsonurl = "\(constants.baseUrl + bannerurl)"
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
        
                                        self.resultarr = (jsonResult as AnyObject).object(forKey: "data") as? NSArray
        
                                       //print("resultarr:\(self.resultarr.count)")
//                                        for i in 0..<self.resultarr.count {
//                                            let details = self.resultarr[i] as? NSDictionary ?? [:]
//                                            let images = details.object(forKey: "eventMobileBannerImage") as! String
//                                            self.imageNames.append(images)
//                                            print("imageindexx:\(self.imageNames)")
//                                        }
                                        DispatchQueue.main.async {
                                            //self.collectionView.delegate = self
                                            //self.collectionView.dataSource = self
                                            self.eventsList.delegate = self
                                            self.eventsList.dataSource = self
        
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
       // self.searchlocationBtn.setTitle("\(cityname)", for: .normal)
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
   
    
    
   
    func loadingIndicator(){
        isAnimationFalse = false
        var loadingSupport = LoadingSupport()
        loadingSupport = self.storyboard?.instantiateViewController(withIdentifier: "LoadingSupport") as! LoadingSupport
        addChild(loadingSupport)
        self.view.addSubview(loadingSupport.view)
    }
   
   
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.addLeftBarbtnIcon(named: "logo_Icon")
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        geteventsList()
        topspendingList()
        
    }
    func geteventsList()  {
        let Url = constants.baseUrl + "/ws/getAllregisteredRestaurantsListByRating?latitude=\(lat)&longitude=\(lng)"
        
        if lat != "" && lng != ""{
            minOffset = 0
            showSwiftLoader()
            
            RestuarentListParser.getRestuarentsList(Url:Url){(responce) in
                
                self.hideSwiftLoader()
                self.restaurentListModel = responce.restuarentList.first
                self.minOffset = self.minOffset + 5
                DispatchQueue.main.async {
                   if self.restaurentListModel.vendorName.count == 0{
                    self.noeventsView.isHidden = false
                   
                    }else{
                        self.noeventsView.isHidden  = true
                       
                        
                    }
                    self.eventsList.delegate = self
                    self.eventsList.dataSource = self
                    self.eventsList.reloadData()
                }
            }
        }
    }
    
    @objc func setLocationForRestaurents(){
      var chooseLocCon = ChooseLocationController()
        chooseLocCon = self.storyboard?.instantiateViewController(withIdentifier: "ChooseLocationController") as! ChooseLocationController
        chooseLocCon.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(chooseLocCon, animated: true)
    }
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            currentLocation = locValue
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            locationManager.stopUpdatingLocation()
            manager.delegate = nil
        let Url = constants.baseUrl + "/ws/getAllregisteredRestaurantsListByRating?latitude=\(lat)&longitude=\(lng)"
        RestuarentListParser.getRestuarentsList(Url:Url){(responce) in
            self.restaurentListModel = responce.restuarentList.first
            self.minOffset = self.minOffset + 5
            DispatchQueue.main.async {
               if self.restaurentListModel.vendorName.count == 0{
                self.noeventsView.isHidden = false

                self.browsBtn.layer.cornerRadius = 20
                
                self.browsBtn.addTarget(self, action: #selector(self.setLocationForRestaurents), for: .touchUpInside)
                }else{
                    self.noeventsView.isHidden  = true
                    
                }
                self.eventsList.reloadData()
            }
        }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
   

    @objc func paginateMore(){
        let Url = constants.baseUrl + "/ws/getAllregisteredRestaurantsListByRating?latitude=\(lat)&longitude=\(lng)"
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
                        self.eventsList.bottomRefreshControl = nil
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
                self.eventsList.reloadData()
                self.refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                self.refreshControl?.triggerVerticalOffset = 10.0
                self.refreshControl?.addTarget(self, action: #selector(self.paginateMore), for: .valueChanged)
                self.eventsList.bottomRefreshControl = self.refreshControl
                 }
               }
            }
        }
        else{
            let url = constants.baseUrl + "/ws/getAllregisteredRestaurantsListByRating?latitude=\(lat)&longitude=\(lng)"
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
                        self.eventsList.bottomRefreshControl = nil
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
                self.eventsList.reloadData()
                self.refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                self.refreshControl?.triggerVerticalOffset = 10.0
                self.refreshControl?.addTarget(self, action: #selector(self.paginateMore), for: .valueChanged)
                self.eventsList.bottomRefreshControl = self.refreshControl
                 }
               }
            }
        }
    }
    
   

    
    @objc func navigateExploreer(_sender: UIButton){
        var exploreResCon = EventsOfClub()
        exploreResCon = self.storyboard?.instantiateViewController(withIdentifier: "EventsOfClub") as! EventsOfClub
        exploreResCon.modelDict = self.restaurentListModel.data[_sender.tag] as! [String : Any]
        
        
//        exploreResCon.restaurentListModel = self.restaurentListModel
//        exploreResCon.intForRestaurent = _sender.tag
//        exploreResCon.restuarentUUID = self.restaurentListModel.vendorUUID[_sender.tag]
//        print(self.restaurentListModel.vendorUUID[_sender.tag])
//        exploreResCon.restuarentName = self.restaurentListModel.vendorName[_sender.tag]
        self.navigationController?.pushViewController(exploreResCon, animated: false)
        
    }
    @objc func navigateToServices(_sender: UIButton){
        var eventsCon = ClubEventsController()
        eventsCon = self.storyboard?.instantiateViewController(withIdentifier: "ClubEventsController") as! ClubEventsController
        eventsCon.vendorUUID = self.restaurentListModel.vendorUUID[_sender.tag]
        self.navigationController?.pushViewController(eventsCon, animated: true)
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
                            let imageData = downloadedImage.jpegData(compressionQuality: 0.2)
                            imageViews.image = UIImage(data: imageData!)
                        }
                    }
                }
            }).resume()
        }
    }
    
    @IBAction func chatAct(_ sender: Any) {
       // Freshchat.sharedInstance().showConversations(self)
    }
    
    
}

//extension EventsView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//            if self.restaurentListModel != nil{
//               return self.restaurentListModel.data.count
//
//            }else{
//                return 0
//            }
//
//
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsCollection", for: indexPath) as! EventsCollection
//            if self.restaurentListModel != nil{
//                if isSearching {
//                    let constants = Constants()
//
//                    self.imageFromServerURL(URLString: "\(constants.baseUrl+self.restaurentListModel.vendorProfileImg[indexPath.item])", placeHolder: UIImage.init(named: "vimage.jpeg"), imageView: cell.eventsImg)
//                    cell.titleLbl.text = searchClubs[indexPath.item]
//                    cell.locationLbl.text = self.restaurentListModel.location[indexPath.item]
//                    cell.itemsLbl.text = self.restaurentListModel.bestSellingItems[indexPath.item]
//
//                }
//                else{
//                let constants = Constants()
//
//                self.imageFromServerURL(URLString: "\(constants.baseUrl+self.restaurentListModel.vendorProfileImg[indexPath.item])", placeHolder: UIImage.init(named: "vimage.jpeg"), imageView: cell.eventsImg)
//                cell.titleLbl.text = self.restaurentListModel.vendorName[indexPath.item]
//                cell.locationLbl.text = self.restaurentListModel.location[indexPath.item]
//                cell.itemsLbl.text = self.restaurentListModel.bestSellingItems[indexPath.item]
//
//                }
//
//            }
//            cell.exploreBtn.tag = indexPath.item
//            cell.eventsBtn.tag = indexPath.item
//
//            cell.bgView.layer.masksToBounds = true
//            cell.bgView.layer.cornerRadius = 10
//            if vendorType == "CLUBS" {
//                cell.exploreBtn.addTarget(self, action: #selector(navigateExploreer(_sender:)), for: .touchUpInside)
//                cell.eventsBtn.addTarget(self, action: #selector(navigateToServices(_sender:)), for: .touchUpInside)
//            }
//            else{
//                cell.exploreBtn.addTarget(self, action: #selector(navigateExploreer(_sender:)), for: .touchUpInside)
//                cell.eventsBtn.addTarget(self, action: #selector(navigateToServices(_sender:)), for: .touchUpInside)
//
//            }
//
//
//            return cell
//
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//            return UIEdgeInsets.init(top: 10, left: 5, bottom: 5, right: 10)
//
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//
//            return 5
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//            return 5
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: 340, height: 250)
//
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//            var eventsCon = ClubEventsController()
//            eventsCon = self.storyboard?.instantiateViewController(withIdentifier: "ClubEventsController") as! ClubEventsController
//            eventsCon.vendorUUID = self.restaurentListModel.vendorUUID[indexPath.item]
//            self.navigationController?.pushViewController(eventsCon, animated: true)
//
//
//
//    }
//
//}



extension EventsView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.restaurentListModel != nil{
           return self.restaurentListModel.data.count
            
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsList.dequeueReusableCell(withIdentifier: "EventsTableViewCell", for: indexPath) as! EventsTableViewCell
        if self.restaurentListModel != nil{
            if isSearching {
                let constants = Constants()
                
                self.imageFromServerURL(URLString: "\(constants.baseUrl+self.restaurentListModel.vendorProfileImg[indexPath.item])", placeHolder: UIImage.init(named: "vimage.jpeg"), imageView: cell.eventsImg)
                cell.titleLbl.text = searchClubs[indexPath.item]
                cell.locationLbl.text = self.restaurentListModel.location[indexPath.item]
                cell.itemsLbl.text = self.restaurentListModel.bestSellingItems[indexPath.item]
                
            }
            else{
            let constants = Constants()
            
            self.imageFromServerURL(URLString: "\(constants.baseUrl+self.restaurentListModel.vendorProfileImg[indexPath.item])", placeHolder: UIImage.init(named: "vimage.jpeg"), imageView: cell.eventsImg)
            cell.titleLbl.text = self.restaurentListModel.vendorName[indexPath.item]
            cell.locationLbl.text = self.restaurentListModel.location[indexPath.item]
            cell.itemsLbl.text = self.restaurentListModel.bestSellingItems[indexPath.item]
          
            }

        }
        cell.exploreBtn.tag = indexPath.item
        cell.eventsBtn.tag = indexPath.item
        cell.eventsImg.tag = indexPath.item
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigatetoClubInfo))
        cell.eventsImg.isUserInteractionEnabled = true
        cell.eventsImg.addGestureRecognizer(tapGestureRecognizer)
        
        cell.bgView.layer.masksToBounds = true
        cell.bgView.layer.cornerRadius = 10
        if vendorType == "CLUBS" {
            cell.exploreBtn.addTarget(self, action: #selector(navigateExploreer(_sender:)), for: .touchUpInside)
            cell.eventsBtn.addTarget(self, action: #selector(navigateToServices(_sender:)), for: .touchUpInside)
        }
        else{
            cell.exploreBtn.addTarget(self, action: #selector(navigateExploreer(_sender:)), for: .touchUpInside)
            cell.eventsBtn.addTarget(self, action: #selector(navigateToServices(_sender:)), for: .touchUpInside)
            
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    
}

extension EventsView{
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

extension EventsView{
    @objc  func navigatetoClubInfo(_ sender: UITapGestureRecognizer)
    {
        guard let tag = sender.view?.tag else {
            return}
        var eventsCon = ClubEventsController()
        eventsCon = self.storyboard?.instantiateViewController(withIdentifier: "ClubEventsController") as! ClubEventsController
        eventsCon.vendorUUID = self.restaurentListModel.vendorUUID[tag]
        self.navigationController?.pushViewController(eventsCon, animated: true)
    }
}
