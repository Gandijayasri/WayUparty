//
//  ExplorePopUpViewController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 08/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import ActiveLabel

class ExplorePopUpViewController: UIViewController {
    let customType = ActiveType.custom(pattern: "\\s& more\\b")
    var navCon : UINavigationController!
    var basicTitleArray = Array<String>()
    var categoryTitle : String?
    var basicResultArray = Array<String>()
    var menuListTitles = Array<String>()
    var restaurentListModel:RestuarentListModel! = nil
    var restuarentDetailsModel:RestuarentDetailsModel! = nil
    var intForRestaurent = Int()
    @IBOutlet weak var tableView: UITableView!
    var type : String?
    var categoryName: String?
    var imagesArray = Array<String>()
    var workingHoursDays = Array<String>()
    var workingHoursStartTime = Array<String>()
    var workingHoursEndTime = Array<String>()
    let imageCache = NSCache<AnyObject, AnyObject>()
    @IBOutlet weak var blurView: UIVisualEffectView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
        print(self.restaurentListModel.costForTwoPeople)
        print(self.restuarentDetailsModel.categoriesList)
        if self.categoryName == "Basic"{
            basicTitleArray = ["Cost for Two :","Vendor Capacity :","Established Year :","Best Selling Items :","Email Address :"]
           // basicResultArray = ["2500","100","2016","Jalapeno Italian & more","soro@disconox.com"]
        }
        if categoryName == "Address"{
         basicTitleArray = ["Phone Number :","Address Line :","Location :"]
            basicResultArray = ["\(self.restaurentListModel.vendorMobile[intForRestaurent])","\(self.restuarentDetailsModel.vendorAddress)","\(self.restuarentDetailsModel.location)"]
        }
        if categoryName == "Category"{
            menuListTitles = self.restuarentDetailsModel.categoriesList as! [String]
        }
        if categoryName == "Facilities"{
         menuListTitles = self.restuarentDetailsModel.facilitiesList as! [String]
        }
        if categoryName == "Music"{
            menuListTitles = self.restuarentDetailsModel.musicList as! [String]
        }
        if categoryName == "Cuisine"{
         menuListTitles = self.restuarentDetailsModel.cuisineList as! [String]
        }
        if categoryName == "Menu"{ imagesArray = ["uvImage.jpeg","uvImages.jpeg"]}
        if categoryName == "Gallery"{imagesArray = ["img1","img2","img3"]}
        workingHoursDays = self.restuarentDetailsModel.workingHoursList.value(forKey: "workingDay") as! [String]
        workingHoursStartTime = self.restuarentDetailsModel.workingHoursList.value(forKey: "startTime") as! [String]
        workingHoursEndTime = self.restuarentDetailsModel.workingHoursList.value(forKey: "endTime") as! [String]

        self.tableView.backgroundColor = UIColor.clear
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

class BasicTableViewCell:UITableViewCell{
    @IBOutlet weak var basicTitleLbl: UILabel!
    
    @IBOutlet weak var basicResultLbl: ActiveLabel!
}

class CategoryTableViewCell:UITableViewCell{
    @IBOutlet weak var categoryTitle: UILabel!
}

class CategoryHeaderTableViewCell:UITableViewCell{
    
    @IBOutlet weak var headerTitle: UILabel!
}


class WorkingHHoursTableViewCell:UITableViewCell{
    
}

class WorkingHoursResultsTableViewCell:UITableViewCell{
    
    @IBOutlet weak var dayLbl: UILabel!
    
    @IBOutlet weak var startTimeLbl: UILabel!
    
    @IBOutlet weak var endTimeLbl: UILabel!
}

class ImageViewReusableCell:UITableViewCell{
    @IBOutlet weak var shawdowView: UIView!
    
    @IBOutlet weak var cellImageView: UIImageView!
}

extension ExplorePopUpViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.type == "menu"{
            return menuListTitles.count
            
        }
        if self.type == "image"{
            var imgArr = Array<String>()
            if self.categoryName == "Menu"{
                imgArr = (self.restuarentDetailsModel.menuList as? Array<String>)!
            }
            if self.categoryName == "Gallery"{
                imgArr = (self.restuarentDetailsModel.galleryList as? Array<String>)!
            }
            return imgArr.count
            
        }
        if self.type == "key value pair"{return basicTitleArray.count}
        if self.type == "working hours"{
            return workingHoursStartTime.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.type == "working hours"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkingHoursResultsTableViewCell") as! WorkingHoursResultsTableViewCell
            cell.dayLbl.text = workingHoursDays[indexPath.row]
            cell.startTimeLbl.text = workingHoursStartTime[indexPath.row]
            cell.endTimeLbl.text = workingHoursEndTime[indexPath.row]
            return cell
        }
        if self.type == "menu"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
            cell.backgroundColor = .clear
            cell.categoryTitle.text = menuListTitles[indexPath.row]
            return cell
        }
        if self.type == "image"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewReusableCell") as! ImageViewReusableCell
           
            cell.shawdowView.layer.cornerRadius = 16
            cell.shawdowView.layer.masksToBounds = true
            cell.backgroundColor = .clear
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowOffset = .init(width: 0, height: 4)
            cell.layer.shadowRadius = 12
            let constants = Constants()
            var imgArr = Array<String>()
            if categoryName == "Menu"{ imgArr = (self.restuarentDetailsModel.menuList as? Array<String>)!}
            if categoryName == "Gallery"{ imgArr = (self.restuarentDetailsModel.galleryList as? Array<String>)!}
            self.imageFromServerURL(URLString: "\(constants.baseUrl+(imgArr[indexPath.row]))", placeHolder: UIImage.init(named: "noImage.png"), imageView: cell.cellImageView)
            return cell
        }
        if self.type == "key value pair"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicTableViewCell") as! BasicTableViewCell
            cell.basicResultLbl.enabledTypes.append(customType)
            cell.basicResultLbl.urlMaximumLength = 31

            cell.basicResultLbl.customize { label in
                cell.basicResultLbl.text = basicResultArray[indexPath.row]
                cell.basicResultLbl.numberOfLines = 0
                cell.basicResultLbl.lineSpacing = 4
                cell.basicResultLbl.customColor[customType] = UIColor.systemBlue
                cell.basicResultLbl.customSelectedColor[customType] = UIColor.systemBlue
                cell.basicResultLbl.handleCustomTap(for: customType) { _ in print("its Working") }
            }
            cell.basicTitleLbl.text = basicTitleArray[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categoryName
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.type == "menu"{return 43.5}
        if self.type == "key value pair"{return 65}
        if self.type == "working hours"{return 69}
        if self.type == "image"{return 44}
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.type == "working hours"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkingHHoursTableViewCell") as! WorkingHHoursTableViewCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryHeaderTableViewCell") as! CategoryHeaderTableViewCell
            cell.headerTitle.text = categoryName
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.categoryName
        if category == "Cuisine" || category == "Category" || category == "Facilities" || category == "Music"{self.type = "menu"}
        if category == "Menu" || category == "Gallery"{self.type = "image"}
        if category == "Basic" || category == "Address"{
            self.type = "key value pair"
            
        }
//        if self.type == "image"{
//            print("Count:\(self.imagesArray.count)")
//            let imageInfo   = GSImageInfo(image: UIImage(named: self.imagesArray[indexPath.row])!, imageMode: .aspectFit)
//            let imageViewer = GSImageViewerController(imageInfo: imageInfo)
//            present(imageViewer, animated: true, completion: nil)
//        }
//        
    }
}
