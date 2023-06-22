//
//  ChooseLocationController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 24/01/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import UIKit
import GooglePlaces

class ChooseLocationController: UIViewController {
    let imageCache = NSCache<AnyObject, AnyObject>()
    var getAvailbleCitiesModel:GetAvaialbleCitiesModel?
    @IBOutlet weak var tableView: UITableView!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
       
            self.resultsViewController = GMSAutocompleteResultsViewController()
            self.resultsViewController?.delegate = self

            self.searchController = UISearchController(searchResultsController: self.resultsViewController)
            self.searchController?.searchResultsUpdater = self.resultsViewController

            // Put the search bar in the navigation bar.
            self.searchController?.searchBar.frame = CGRect(x: 80, y: 0, width: 200, height: 35)
            self.searchController?.searchBar.searchTextField.textColor = UIColor.white
        let searchVw = UIView(frame: CGRect(x: 80, y: 36, width: 200, height: 1))
        searchVw.backgroundColor = UIColor.yellow
       
        if let textfield = self.searchController?.searchBar.value(forKey: "searchField") as? UITextField {

            textfield.backgroundColor = UIColor.clear
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])

            textfield.textColor = UIColor.white

            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.white
            }
        }
        
            navigationItem.titleView = self.searchController?.searchBar
          
        let backBtn = UIBarButtonItem(image: UIImage(named: "backWhite.png"), style: .plain, target: self, action: #selector(backtoHome))
             self.navigationItem.leftBarButtonItem  = backBtn
             self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white

            
            definesPresentationContext = true

            
            self.searchController?.hidesNavigationBarDuringPresentation = false
       
        DispatchQueue.main.async {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChooseLocationController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        GetAvaialableCitiesParser.GetAvaialbleCitiesAPI(){(location) in
            
            
            self.getAvailbleCitiesModel = location.getAvaialbleCitiesModel.first
            
            DispatchQueue.main.async {
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    @objc func backtoHome(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
        
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
    
//    @IBAction func backAct(_ sender: Any) {
//        let story = UIStoryboard(name: "Main", bundle: nil)
//        let homeVC = story.instantiateViewController(withIdentifier: "HomeController") as! HomeController
//        self.navigationController?.pushViewController(homeVC, animated: true)
//    }
}

class ChooseLocationCell:UITableViewCell{
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var cityLbl: UILabel!
}

extension ChooseLocationController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.getAvailbleCitiesModel?.cityName.count ?? 0 != 0{
            return self.getAvailbleCitiesModel?.cityName.count ?? 0
        }else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseLocationCell") as! ChooseLocationCell
        cell.cityLbl.text = self.getAvailbleCitiesModel?.cityName[indexPath.row]
        let constants = Constants()
        self.imageFromServerURL(URLString: constants.baseUrl + (self.getAvailbleCitiesModel?.cityImage[indexPath.row] ?? ""), placeHolder: UIImage.init(named: "noImg.png"), imageView: cell.cityImageView)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = story.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
        homeVC.modalPresentationStyle = .fullScreen
        lat = self.getAvailbleCitiesModel?.latitude[indexPath.row] ?? ""
        lng = self.getAvailbleCitiesModel?.longitude[indexPath.row] ?? ""
        cityname = self.getAvailbleCitiesModel?.cityName[indexPath.row] ?? ""
        dealsAndOffersOn = false
        //self.present(homeVC, animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        Screen_navgation = 1
        
        
        //self.navigationController?.pushViewController(homeVC, animated: true)
        
      
    }
}
extension ChooseLocationController: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didAutocompleteWith place: GMSPlace) {
    searchController?.isActive = false
    // Do something with the selected place.
//    print("Place name: \(place.name)")
//    print("Place address: \(place.formattedAddress)")
//    print("Place attributions: \(place.attributions)")
    print(place.coordinate.latitude)
    print(place.coordinate.longitude)
    DispatchQueue.main.async {
   
    let story = UIStoryboard(name: "Main", bundle: nil)
    let homeVC = story.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
    homeVC.modalPresentationStyle = .fullScreen
    lat = String(place.coordinate.latitude)
    lng = String(place.coordinate.longitude)
    cityname = "\(place.formattedAddress ?? "")"
    self.present(homeVC, animated: true, completion: nil)
  }
    
  }

  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didFailAutocompleteWithError error: Error){
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}
