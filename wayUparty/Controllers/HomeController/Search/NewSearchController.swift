//
//  NewSearchController.swift
//  wayUparty
//
//  Created by Arun  on 11/05/23.
//  Copyright © 2023 Arun. All rights reserved.
//

import UIKit

class NewSearchController: UIViewController {
    
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var searchCollection: UICollectionView!
    
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var navViewHeight: NSLayoutConstraint!
    var isfromDeals:Bool = false
    var restaurentListModel:RestuarentListModel! = nil
    var searchClubs = [String]()
    var isSearching = false
    var vendorType = ""
    let imageCache = NSCache<AnyObject, AnyObject>()
    var category_uuid = ""
    var categ_id:Int = 0
    var selectedDeal = ""
    var type = ""
    
    var minOffset:Int = 0
    let contants = Constants()
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.vendorType = "CLUBS"
        registerCollectioncell()
        searchTF.addTarget(self, action: #selector(serachClubswithtext(_:)), for: .editingChanged)
       
    }
    func setUIElements()  {
        searchTF.attributedPlaceholder = NSAttributedString(
            string: "Search for clubs or restaurents",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        hideKeyboardWhenTappedAround()
        if isfromDeals == false{
            searchTF.isHidden = false
            navView.isHidden = false
            self.navigationController?.isNavigationBarHidden = true
            self.navViewHeight.constant = 100
        }else{
            searchTF.isHidden = true
            navView.isHidden = true
            self.navViewHeight.constant = 0
            self.navigationController?.isNavigationBarHidden = false
            let backButton = UIBarButtonItem()
            backButton.title = "\(selectedDeal)"
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
            self.getDealsAvailablerestaurents()
        }
        
        searchTF.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        setUIElements()
    }
    func registerCollectioncell()  {
        searchCollection.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: "SearchCell")
    }

    
    @objc func serachClubswithtext(_ textfield:UITextField){
        if textfield.text != ""{
            getSearchList(searchStr: self.searchTF.text ?? "")
        }else{
            
            getSearchList(searchStr: self.searchTF.text ?? "" )
        }
        
    }
    

    @IBAction func backAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    func getDealsAvailablerestaurents()  {
        
        
        let url = contants.baseUrl + "/ws/getAllregisteredRestaurantsListByRating?latitude=\(lat)&longitude=\(lng)&deals=Y&categoryId=\(self.categ_id)"
        print(url)
        
        RestuarentListParser.getRestuarentsList(Url: url){(responce) in
            self.restaurentListModel = responce.restuarentList.first
            self.minOffset = self.minOffset + 5
            DispatchQueue.main.async {
               
                self.searchCollection.dataSource = self
                self.searchCollection.delegate = self
                self.searchCollection.reloadData()
            }
        }
    }
    func getSearchList(searchStr:String)  {
        
        let search_url = "\(contants.baseUrl)/ws/getRegisteredRestaurantsListByName?latitude=\(lat)&longitude=\(lng)&searchString=\(searchStr)"
        print(search_url)
        
        RestuarentListParser.getRestuarentsList(Url: search_url){(responce) in
            self.restaurentListModel = responce.restuarentList.first
            if(self.restaurentListModel.data.count == 0){
                self.isSearching = false
            }else{
                self.isSearching = true
            }
            DispatchQueue.main.async {
               
                self.searchCollection.dataSource = self
                self.searchCollection.delegate = self
                self.searchCollection.reloadData()
            }
        }
        
        
        
    }
    
    func navigatetoDealsScreen(vendoruuid:String)  {
        showSwiftLoader()
        GetServicesListModelParser.GetServiceListAPI(categoryUUID: self.category_uuid, vendorUUID: vendoruuid){(responce) in
            self.hideSwiftLoader()
            print(responce.getServicesListModel.first?.serviceUUID ?? Array<String>())
            DispatchQueue.main.async {
                var resusableBookingServiceCon = ReusableBookingServiceController()
                resusableBookingServiceCon = self.storyboard?.instantiateViewController(withIdentifier: "ReusableBookingServiceController") as! ReusableBookingServiceController
                  resusableBookingServiceCon.type = "Deals"
                resusableBookingServiceCon.dealSubType =  self.selectedDeal
                resusableBookingServiceCon.serviceId =  (responce.getServicesListModel.first?.serviceUUID)!
                resusableBookingServiceCon.vendorId = vendoruuid
                resusableBookingServiceCon.getServicesListModel = responce.getServicesListModel.first
                    resusableBookingServiceCon.serviceType = "Deals"
                    resusableBookingServiceCon.discountType = responce.getServicesListModel.first!.discountType
                if self.selectedDeal == "The WayU Party"{
                        print(responce.getServicesListModel.first?.packageMenuItems ?? NSArray())
                         let itemsOffered = responce.getServicesListModel.first?.packageMenuItems.value(forKey: "itemsOffered") as? NSArray
                         let menuItems = responce.getServicesListModel.first?.packageMenuItems.value(forKey: "menuItem") as? NSArray
                         let menuItemUUID = responce.getServicesListModel.first?.packageMenuItems.value(forKey: "menuItemUUID") as? NSArray
                         let menuItemsList = responce.getServicesListModel.first?.packageMenuItems.value(forKey: "menuItemsList") as? NSArray
                        resusableBookingServiceCon.itemsOffered = itemsOffered!
                        resusableBookingServiceCon.menuItemUUID = menuItemUUID!
                        resusableBookingServiceCon.menuItem = menuItems!
                        resusableBookingServiceCon.menuItemsList = menuItemsList!
                        resusableBookingServiceCon.serviceType = "The WayU Party"
                    resusableBookingServiceCon.packageName = self.selectedDeal
                    }
                self.navigationController?.pushViewController(resusableBookingServiceCon, animated: true)
            }
            
        }
    }

}



extension NewSearchController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isfromDeals == false && isSearching == true{
           return self.restaurentListModel.data.count
        }else if isfromDeals == true {
            return self.restaurentListModel.data.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchCollection.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as? SearchCell else{ return UICollectionViewCell()}
       
            if isfromDeals == false && isSearching == true{
                if self.restaurentListModel != nil{
                    
                    
                    self.imageFromServerURL(URLString: "\(self.contants.baseUrl+self.restaurentListModel.vendorProfileImg[indexPath.item])", placeHolder: UIImage.init(named: "vimage.jpeg"), imageView: cell.resImageView)
                    cell.restaurentTitle.text = restaurentListModel.vendorName[indexPath.row]
                    cell.restuarentLocation.text = self.restaurentListModel.location[indexPath.item]
                    
                    cell.servicelbl.text = self.restaurentListModel.bestSellingItems[indexPath.item]
                    cell.servicesIconBtn.tag = indexPath.item
                    cell.servicesTextBtn.tag = indexPath.item
                    cell.servicesVw.layer.masksToBounds = true
                    cell.servicesVw.layer.cornerRadius = 10
                    if vendorType == "CLUBS" {
                        cell.servicesIconBtn.addTarget(self, action: #selector(navigateExploreer(_sender:)), for: .touchUpInside)
                        cell.servicesTextBtn.addTarget(self, action: #selector(navigateToServices), for: .touchUpInside)
                    }
                    else{
                        cell.servicesIconBtn.addTarget(self, action: #selector(navigateExploreer(_sender:)), for: .touchUpInside)
                        
                    }
                    
                }
                
                
            }else if isfromDeals == true{
                if self.restaurentListModel != nil{
                    
                    
                    self.imageFromServerURL(URLString: "\(self.contants.baseUrl+self.restaurentListModel.vendorProfileImg[indexPath.item])", placeHolder: UIImage.init(named: "vimage.jpeg"), imageView: cell.resImageView)
                    cell.restaurentTitle.text = restaurentListModel.vendorName[indexPath.row]
                    cell.restuarentLocation.text = self.restaurentListModel.location[indexPath.item]
                    
                    cell.servicelbl.text = self.restaurentListModel.bestSellingItems[indexPath.item]
                    cell.servicesIconBtn.tag = indexPath.item
                    cell.servicesTextBtn.tag = indexPath.item
                   
                    
                    cell.servicesVw.layer.masksToBounds = true
                    cell.servicesVw.layer.cornerRadius = 10
                    if vendorType == "CLUBS" {
                        cell.servicesIconBtn.addTarget(self, action: #selector(navigateExploreer(_sender:)), for: .touchUpInside)
                        cell.servicesTextBtn.addTarget(self, action: #selector(navigateToServices), for: .touchUpInside)
                    }
                    else{
                        cell.servicesIconBtn.addTarget(self, action: #selector(navigateExploreer(_sender:)), for: .touchUpInside)
                        
                    }
                    
                }
            }
        cell.resImageView.tag = indexPath.item
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigatetoClubInfo))
        cell.resImageView.isUserInteractionEnabled = true
        cell.resImageView.addGestureRecognizer(tapGestureRecognizer)
        
        return cell
        
    }
    
    
}
extension NewSearchController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if isfromDeals == true{
//           let vendorUUId = self.restaurentListModel.vendorUUID[indexPath.row]
//            navigatetoDealsScreen(vendoruuid: vendorUUId)
//
//        }else{
//            if self.vendorType == "CLUBS" {
//                var servicesCon = ServicesController()
//                servicesCon = self.storyboard?.instantiateViewController(identifier: "ServicesController") as! ServicesController
//                servicesCon.vendorUUID = self.restaurentListModel.vendorUUID[indexPath.item]
//                self.navigationController?.pushViewController(servicesCon, animated: true)
//            }else if isfromDeals == true{
//
//            }
//            else{
//                var eventsCon = ClubEventsController()
//                eventsCon = self.storyboard?.instantiateViewController(withIdentifier: "ClubEventsController") as! ClubEventsController
//                eventsCon.vendorUUID = self.restaurentListModel.vendorUUID[indexPath.item]
//                self.navigationController?.pushViewController(eventsCon, animated: true)
//
//            }
//        }
        
    }
    
}

extension NewSearchController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 5, bottom: 5, right: 10)
            
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 60) / 2.0
        return CGSize(width: width, height: 296)
       
    }
    func columnWidth(for collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> CGFloat{
          return self.searchCollection.frame.size.width / 2 - 40
           
       }

   func maximumNumberOfColumns(for collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> Int {
                   let numColumns: Int = Int(2.0)
                   return numColumns
           }
}


extension NewSearchController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension NewSearchController{
    @objc func navigateExploreer(_sender: UIButton){

        var exploreResCon = EventsOfClub()
        exploreResCon = self.storyboard?.instantiateViewController(withIdentifier: "EventsOfClub") as! EventsOfClub
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
}



extension NewSearchController{
    @objc func navigatetoClubInfo(_ sender: UITapGestureRecognizer){
        guard let tag = sender.view?.tag else {
            return}
        if isfromDeals == true{
           let vendorUUId = self.restaurentListModel.vendorUUID[tag]
            navigatetoDealsScreen(vendoruuid: vendorUUId)
            
        }else{
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
}
