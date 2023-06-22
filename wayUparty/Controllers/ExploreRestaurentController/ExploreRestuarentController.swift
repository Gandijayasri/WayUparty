//
//  ExploreRestuarentController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 02/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import CHIPageControl
import MSPeekCollectionViewDelegateImplementation
import ShimmerSwift
class ExploreRestuarentController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var pageControls:[CHIPageControlJaloro]!
    var productImagesArray = Array<String>()
    var behavior: MSCollectionViewPeekingBehavior!
    var ProductPicturesCollectionView:UICollectionView?
    var iconImagesArray = Array<String>()
    var titleImagesArray = Array<String>()
    var restaurentListModel:RestuarentListModel! = nil
    var restuarentDetailsModel:RestuarentDetailsModel! = nil
    var intForRestaurent = Int()
    let imageCache = NSCache<AnyObject, AnyObject>()
    var restuarentUUID = String()
    var restuarentName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        RestuarentDetailsModelParser.getRestuarentsListDetails(uuid: restuarentUUID){(responce) in
            self.restuarentDetailsModel = responce.restuarentDetailsModel.first!
            print(self.restuarentDetailsModel)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        self.title = restuarentName
        iconImagesArray = ["basic","adress","category","menu-1","facilities","music","cuisine","workingHours","terms","gallery","ratings"]
        titleImagesArray = ["Basic","Address","Category","Menu","Facilities","Music","Cuisine","Working Hours","Terms & Conditions","Gallery","Reviews & Ratings"]
        self.tableView.delegate = self
        self.tableView.dataSource = self
      // productImagesArray = ["img1","img2","img3"]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.ProductPicturesCollectionView{
        let total = scrollView.contentSize.width - scrollView.bounds.width - 2
        let offset = scrollView.contentOffset.x
        let percent = Double(offset / total)
        var progress = Double()
            let imgArr = self.restuarentDetailsModel.sliderList as? Array<String>
            progress = percent * Double((imgArr?.count ?? 0) - 1)
        if self.pageControls != nil{
            (self.pageControls).forEach { (control) in
                let y = Double(round(1000*progress)/1000)
                control.progress = y
            }}
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func setPropertiesForJaloro(jalora:CHIPageControlJaloro){
        if UIScreen.main.bounds.height == 568{
          jalora.elementWidth = 10.0
          jalora.elementHeight = 2.0
          jalora.padding = 5.0
          jalora.radius = 2.0
        }
        if UIScreen.main.bounds.height == 667{
            jalora.elementWidth = 12.0
            jalora.elementHeight = 4.0
            jalora.padding = 7.0
            jalora.radius = 2.0
        }
        if UIScreen.main.bounds.height == 736{
            jalora.elementWidth = 14.0
            jalora.elementHeight = 6.0
            jalora.padding = 7.0
            jalora.radius = 2.0
        }
        if UIScreen.main.bounds.height == 812 || UIScreen.main.bounds.size.height == 896.0 {
            jalora.elementWidth = 12.0
            jalora.elementHeight = 4.0
            jalora.padding = 7.0
            jalora.radius = 2.0
        }
        if UIScreen.main.bounds.height == 1024 || UIScreen.main.bounds.size.height == 1112.0 ||  UIScreen.main.bounds.size.height == 1194.0{
            jalora.elementWidth = 20.0
            jalora.elementHeight = 8.0
            jalora.padding = 10.0
            jalora.radius = 4.0
        }
    }
    
    func reloadDelegate() {
        behavior = MSCollectionViewPeekingBehavior(cellSpacing: 10, cellPeekWidth: 0, maximumItemsToScroll: 1, numberOfItemsToShow: 1, scrollDirection: .horizontal)
        self.ProductPicturesCollectionView?.configureForPeekingBehavior(behavior: behavior)
        self.ProductPicturesCollectionView?.reloadData()
    }
    
}

extension ExploreRestuarentController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreRestuarentTableViewCell") as! ExploreRestuarentTableViewCell
            self.ProductPicturesCollectionView = cell.weaverProductPicturesCollectionView
            self.pageControls = [cell.pageControl]
            self.setPropertiesForJaloro(jalora: cell.pageControl)
            self.pageControls.forEach { (controls) in
                if restuarentDetailsModel != nil {
            let imgArr = self.restuarentDetailsModel.sliderList as? Array<String>
                    controls.numberOfPages = imgArr?.count ?? 0}}
            reloadDelegate()
            self.ProductPicturesCollectionView?.delegate = self
            self.ProductPicturesCollectionView?.dataSource = self
            return cell
        }
        else{
         let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreRestuarentMenuCell") as! ExploreRestuarentMenuCell
            cell.iconImgView.image = UIImage.init(named: self.iconImagesArray[indexPath.row])
            cell.titleLbl.text = self.titleImagesArray[indexPath.row]
            cell.shimmersView.contentView = cell.titleLbl
            cell.shimmersView.isShimmering = true
            cell.shimmersView.shimmerSpeed = 150
            cell.shimmersView.shimmerAnimationOpacity = 0.1
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if indexPath.section == 1{
            guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "ExplorePopUpViewController") as? ExplorePopUpViewController else { return }
            popupVC.restaurentListModel = self.restaurentListModel
            popupVC.restuarentDetailsModel = self.restuarentDetailsModel
            popupVC.intForRestaurent = self.intForRestaurent
        let category = self.titleImagesArray[indexPath.row]
            if category == "Cuisine" || category == "Category" || category == "Facilities" || category == "Music"{
                popupVC.type = "menu"
                popupVC.categoryName = titleImagesArray[indexPath.row]
                popupVC.categoryTitle = category
                
                self.present(popupVC, animated: true, completion: nil)
            }
            if category == "Menu" || category == "Gallery"{
             popupVC.type = "image"
                popupVC.categoryName = titleImagesArray[indexPath.row]
                popupVC.categoryTitle = category
                
                self.present(popupVC, animated: true, completion: nil)
            }
            if category == "Basic" || category == "Address"{
                popupVC.type = "key value pair"
                popupVC.categoryName = titleImagesArray[indexPath.row]
                popupVC.categoryTitle = category
                let sellingItems = self.restaurentListModel.bestSellingItems[intForRestaurent]
                let sellingItemArray = sellingItems.components(separatedBy: ",")
                    
                popupVC.basicResultArray =  ["\(self.restaurentListModel.costForTwoPeople[intForRestaurent])","\(self.restuarentDetailsModel.vendorCapacity)","\(self.restuarentDetailsModel.establishedYear)","\(sellingItemArray[0]+" & more")","\(self.restaurentListModel.vendorEmail[intForRestaurent])"]
                self.present(popupVC, animated: true, completion: nil)
            }
            if category == "Working Hours"{
              popupVC.type = "working hours"
                popupVC.categoryName = titleImagesArray[indexPath.row]
                popupVC.categoryTitle = category
                
                self.present(popupVC, animated: true, completion: nil)
            }
            
            if category == "Reviews & Ratings"{
                var commentCon = CommentsController()
                commentCon = self.storyboard?.instantiateViewController(identifier: "CommentsController") as! CommentsController
                commentCon.restuarentUUID = restuarentUUID
                self.navigationController?.pushViewController(commentCon, animated: true)
            }
            if category == "Terms & Conditions"{
                var termsAndConditions = TermsAndConditionsController()
                termsAndConditions = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionsController") as! TermsAndConditionsController
                termsAndConditions.vendorUUID = self.restuarentUUID
                self.navigationController?.pushViewController(termsAndConditions, animated: true)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{return 1}
        else{
            return iconImagesArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{return 343}
        else{
            return 65
        }
        
    }
}

extension ExploreRestuarentController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestuarentExploreCollectionViewCell", for: indexPath) as! RestuarentExploreCollectionViewCell
        if restuarentDetailsModel != nil{
        let imgArr = self.restuarentDetailsModel.sliderList as? Array<String>
        let constants = Constants()
            if imgArr?.count != 0{
            self.imageFromServerURL(URLString: "\(constants.baseUrl+(imgArr?[indexPath.row])!)", placeHolder: UIImage.init(named: "noImage.png"), imageView: cell.productImageView)
            }}
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if restuarentDetailsModel != nil{
        let imgArr = self.restuarentDetailsModel.sliderList as? Array<String>
            return imgArr?.count ?? 0}
        else{return 0}
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    return CGSize(width: 375, height: 286)
    }
    
    
}

class ExploreRestuarentMenuCell:UITableViewCell{
    @IBOutlet weak var shimmersView: ShimmeringView!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
}


extension ExploreRestuarentController: BottomPopupDelegate {
    
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
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}
