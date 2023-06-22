//
//  EventsOfClub.swift
//  wayUparty
//
//  Created by Arun  on 03/05/23.
//  Copyright © 2023 Arun . All rights reserved.
//

import UIKit

class EventsOfClub: UIViewController {
    
    @IBOutlet weak var eventsListCollection: UICollectionView!
    var titlesArr = ["Info","Schedule","Address","T & C","Facilities","Gallery","Review&Ratings"]
    var imagesArr = ["basic-01.png","Working hours-01.png","address location-01.png","T&C-01.png","Facilities-01.png","gallery-01.png","Review & Rating-01.png"]
    
    var modelDict = [String: Any]()
    var restuarentUUID = String()
    var restuarentDetailsModel:RestuarentDetailsModel! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restuarentUUID = self.modelDict["vendorUUID"] as? String ?? ""
        registercollectionCells()
        showSwiftLoader()
        RestuarentDetailsModelParser.getRestuarentsListDetails(uuid: restuarentUUID){(responce) in
            self.hideSwiftLoader()
            self.restuarentDetailsModel = responce.restuarentDetailsModel.first!
            
            DispatchQueue.main.async {
                self.eventsListCollection.delegate = self
                self.eventsListCollection.dataSource = self
                self.eventsListCollection.reloadData()
            }
            
        }
       // "vendorUUID": 9lqUDak5
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func registercollectionCells(){
        
        eventsListCollection.register(UINib(nibName: "EventsBanner", bundle: nil), forCellWithReuseIdentifier: "EventsBanner")
        eventsListCollection.register(UINib(nibName: "EventList", bundle: nil), forCellWithReuseIdentifier: "EventList")
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    

}


extension EventsOfClub:UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
            
            
        }else{
            return titlesArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            self.eventsListCollection.isScrollEnabled = true
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let cell = eventsListCollection.dequeueReusableCell(withReuseIdentifier: "EventsBanner", for: indexPath) as! EventsBanner
              cell.slidesArr = self.restuarentDetailsModel.sliderList
              cell.pagerView.delegate = cell.self
              cell.pagerView.dataSource = cell.self
           
            return cell
            
        }else{
            let cell = eventsListCollection.dequeueReusableCell(withReuseIdentifier: "EventList", for: indexPath) as! EventList
            cell.titleLbl.text = titlesArr[indexPath.row]
            cell.imgView.image = UIImage(named: imagesArr[indexPath.row])
            return cell
        }
    }
    
    
}
extension EventsOfClub:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        if indexPath.section == 1{
            if indexPath.row == 0{
                let infovc = story.instantiateViewController(withIdentifier: "InfoView") as! InfoView
                infovc.modelDict = self.modelDict
                self.navigationController?.pushViewController(infovc, animated: false)
                
                
            }else if indexPath.row == 1{
                let scheduleVC = story.instantiateViewController(withIdentifier: "ScheduleVC") as! ScheduleVC
                scheduleVC.workHoursArr = self.restuarentDetailsModel.workingHoursList
                self.navigationController?.pushViewController(scheduleVC, animated: false)
                
            }else if indexPath.row == 2{
                let infovc = story.instantiateViewController(withIdentifier: "AddressView") as! AddressView
                infovc.mobileno = self.restuarentDetailsModel.vendorMobile
                infovc.address = self.restuarentDetailsModel.vendorAddress
                infovc.cityofrest = self.restuarentDetailsModel.location
                self.navigationController?.pushViewController(infovc, animated: false)
                
            }else if indexPath.row == 3{
                let infovc = story.instantiateViewController(withIdentifier: "TermsandConditionsVC") as! TermsandConditionsVC
                infovc.termsandConditions = self.restuarentDetailsModel.termsAndConditions
                self.navigationController?.pushViewController(infovc, animated: false)
                
            }else if indexPath.row == 4{
                let infovc = story.instantiateViewController(withIdentifier: "FacilitiesVC") as! FacilitiesVC
                infovc.facilities = self.restuarentDetailsModel.facilitiesList
                self.navigationController?.pushViewController(infovc, animated: false)
                
            }else if indexPath.row == 5{
                let infovc = story.instantiateViewController(withIdentifier: "GalleryVC") as! GalleryVC
                infovc.galleryArr = self.restuarentDetailsModel.galleryList
                self.navigationController?.pushViewController(infovc, animated: false)
                
            }else if indexPath.row == 6{
                let infovc = story.instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsVC

                self.navigationController?.pushViewController(infovc, animated: false)
            }
        }else{
            
        }
       
    }
    
}
extension EventsOfClub:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0{ return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)}
        else{
            return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 1{
            return 5
        }
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 1{
            return 5
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
        let width = (self.view.frame.size.width-40)
       return CGSize(width: width, height: 180)
        }
        else
       {
       
        
            let width = (view.frame.size.width-30)

        return CGSize(width: width/2, height: 53)}
        
    }
    func columnWidth(for collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> CGFloat
    
       {
        
                   return self.eventsListCollection.frame.size.width / 2 - 40
       }

   func maximumNumberOfColumns(for collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> Int {
                   let numColumns: Int = Int(2.0)
                   return numColumns
           }
   
    
}

