//
//  ServicesController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 14/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import Kingfisher
//import Mobilisten

class ServicesController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let imageCache = NSCache<AnyObject, AnyObject>()
    var serviceUUID : String = ""
    var type : String = ""
    var vendorUUID : String = ""
    var imagesArray = Array<String>()
    var titlesArray = Array<String>()
    var serviceUUIDs = Array<String>()
    var categoryUUIDs = Array<String>()
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    var getServicesModel:GetServicesModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
        
        let backButton = UIBarButtonItem()
        backButton.title = "Services"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        showSwiftLoader()
        GetServiceModelParser.GetServicesListAPI(vendorUUID: self.vendorUUID){(responce) in
            self.hideSwiftLoader()
           
            self.getServicesModel = responce.getServicesModel.first
            
            self.titlesArray = responce.getServicesModel.first!.serviceName as! [String]
            self.titlesArray.remove(at: 3)
            self.imagesArray = responce.getServicesModel.first!.serviceImage as! [String]
            self.imagesArray.remove(at: 3)
            self.serviceUUIDs = responce.getServicesModel.first!.serviceUUID as! [String]
            self.serviceUUIDs.remove(at: 3)
            DispatchQueue.main.async {
              self.collectionView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
       // ZohoSalesIQ.showLauncher(true)
    }
    func loadingIndicator(){
        isAnimationFalse = false
        var loadingSupport = LoadingSupport()
        loadingSupport = self.storyboard?.instantiateViewController(withIdentifier: "LoadingSupport") as! LoadingSupport
        addChild(loadingSupport)
        self.view.addSubview(loadingSupport.view)
    }
    
   
    
    func presentTextPicker(type:String){
        let redAppearance = YBTextPickerAppearanceManager.init(
            
            pickerTitle         : type,
            titleFont           : boldFont,
            //titleTextColor      : UIColor.white,
            // titleBackground     : UIColor.clear,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search Type",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .white,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "",
            
            //doneButtonColor     : UIColor.init(red: 74.0/255.0, green: 157.0/255.0, blue: 100.0/255.0, alpha: 1.0),
            // doneButtonFont      : boldFont,
            
            //itemColor           : .white,
            itemFont            : regularFont
            
        )
        var arrGender = Array<String>()
        GetCategoriesOfServicesParser.GetCategoriesOfServicesParser(serviceUUID:  self.serviceUUID, vendorUUId: self.vendorUUID){(respone) in
            if respone.getCategoriesofService.first?.data != nil{
            arrGender = respone.getCategoriesofService.first?.categoryName as! [String]
            self.categoryUUIDs = respone.getCategoriesofService.first?.categoryUUID as! [String]
            DispatchQueue.main.async {
                let picker = YBTextPicker.init(with: arrGender, appearance: redAppearance,onCompletion: { (selectedIndexes, selectedValues) in
                    if let selectedValue = selectedValues.first{
                        GetServicesListModelParser.GetServiceListAPI(categoryUUID: self.categoryUUIDs[selectedIndexes.first!], vendorUUID: self.vendorUUID){(responce) in
                            print(responce.getServicesListModel.first?.serviceUUID ?? Array<String>())
                            DispatchQueue.main.async {
                                var resusableBookingServiceCon = ReusableBookingServiceController()
                                resusableBookingServiceCon = self.storyboard?.instantiateViewController(withIdentifier: "ReusableBookingServiceController") as! ReusableBookingServiceController
                                resusableBookingServiceCon.type = type
                                resusableBookingServiceCon.dealSubType =  respone.getCategoriesofService.first?.categoryName[selectedIndexes[0]] as! String
                                resusableBookingServiceCon.serviceId =  (responce.getServicesListModel.first?.serviceUUID)!
                                resusableBookingServiceCon.vendorId = self.vendorUUID
                                resusableBookingServiceCon.getServicesListModel = responce.getServicesListModel.first
                                resusableBookingServiceCon.serviceType = self.type
                                resusableBookingServiceCon.discountType = responce.getServicesListModel.first!.discountType
                                if type == "The WayU Party"{
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
                                    resusableBookingServiceCon.packageName = arrGender[selectedIndexes.first!]
                                }
                                self.navigationController?.pushViewController(resusableBookingServiceCon, animated: true)
                            }
                        }
                        print(selectedValue)
                    }else{
                        print("selction")
                    }},
                                               onCancel: {
                    print("Cancelled")
                })
                picker.show(withAnimation: .FromBottom)
            }
        }else{
            DispatchQueue.main.async {
                self.showToast(message: "No Data Found!")
            }
            
        }
    }
    }
    
}

extension ServicesController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCollectionViewCell", for: indexPath) as! ServicesCollectionViewCell
        if self.titlesArray.count != 0{
            
            
            cell.titleLbl.text = self.titlesArray[indexPath.row]
            let constants = Constants()
           // self.loadingIndicator()
            cell.shawdowViewImageView.layer.cornerRadius = cell.shawdowViewImageView.frame.height * 0.5
            if let picUrl = URL(string: constants.baseUrl + "\(self.imagesArray[indexPath.row])") {
            
             let resource = ImageResource(downloadURL: picUrl)
                KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                       
                        cell.shawdowViewImageView.image = value.image.resizeWith(percentage: 0.25)
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }

        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{

        return CGSize.init(width: collectionView.frame.size.width/4, height: collectionView.frame.size.height/4)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.serviceUUID = serviceUUIDs[indexPath.row]
        self.type = titlesArray[indexPath.row]
        if self.type ==  "Events"{
            print(self.vendorUUID)
//            var eventsCon = EventsController()
//            eventsCon = self.storyboard?.instantiateViewController(withIdentifier: "EventsController") as! EventsController
//            eventsCon.vendorUUID = self.vendorUUID
//            self.navigationController?.pushViewController(eventsCon, animated: true)
//            return
            var eventsCon = ClubEventsController()
            eventsCon = self.storyboard?.instantiateViewController(withIdentifier: "ClubEventsController") as! ClubEventsController
            eventsCon.vendorUUID = self.vendorUUID
            eventsCon.isfromHome = true
            self.navigationController?.pushViewController(eventsCon, animated: true)
        }else{
            isEntryRistricted = self.getServicesModel.isEntryRatioEnabled[indexPath.row] as! String
            menRatio = 0
            womenRatio = 0
           self.presentTextPicker(type: titlesArray[indexPath.row])
        }
       
    }
     func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeRotation(10, 1, 1, 0)
         UIView.animate(withDuration:0.25, delay: 0.15*Double(indexPath.row),animations: { () -> Void in
        cell.alpha = 1

            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        })
         
    }
}

class ServicesCollectionViewCell:UICollectionViewCell{
   
    
    @IBOutlet weak var shawdowView: UIView!
    @IBOutlet weak var shawdowViewImageView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    
    override func awakeFromNib() {
        shawdowView.layer.cornerRadius = 40
        shawdowView.backgroundColor = UIColor.lightGray
        shawdowViewImageView.backgroundColor = UIColor.black
        
        
        
    }
    
   
    
}






