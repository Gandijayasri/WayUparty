//
//  SetYourLocation.swift
//  wayUparty
//
//  Created by Arun on 27/02/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import UIKit
import CoreLocation

class SetYourLocation: UIViewController,CLLocationManagerDelegate {
    @IBOutlet var setLocationBtn: UIButton!
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    var minOffset:Int = 0
    var limit:Int = 5
    var addressString : String = ""
    
    @IBOutlet var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.loadgifImage()
            self.SetUIElements()
        }
       
        NotificationCenter.default.addObserver(self, selector: #selector(SetYourLocation.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        let status = CLLocationManager.authorizationStatus()
       
           switch status {
               // 1
           case .notDetermined:
                   locationManager.requestWhenInUseAuthorization()
                  // return

               // 2
           case .denied, .restricted:
               let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               alert.addAction(okAction)

               present(alert, animated: true, completion: nil)
               return
           case .authorizedAlways, .authorizedWhenInUse:
               break
            
           

           @unknown default:
            fatalError()
           }

        
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
        
        
          
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigatetoHomeScreen()
    }
    
    func navigatetoHomeScreen()  {
        if Screen_navgation == 1{
            let story = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = story.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func navToSelectCountryScreen() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SelectCountryVC") as? SelectCountryVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
   
    func SetUIElements() {
        setLocationBtn.layer.cornerRadius = 22
        self.navigationController?.isNavigationBarHidden = true
        }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lat = "\(locValue.latitude)"
        lng = "\(locValue.longitude)"
            print("locations = \(lat) \(lng)")
            locationManager.stopUpdatingLocation()
            manager.delegate = nil
        let geocoder = CLGeocoder()
      

        let location = CLLocation(latitude:(lat as NSString).doubleValue , longitude:(lng as NSString).doubleValue )
         geocoder.reverseGeocodeLocation(location) {
             (placemarks, error) -> Void in
            let status = Reach().connectionStatus()
            let story = UIStoryboard(name: "Main", bundle: nil)
            let neworVc = story.instantiateViewController(withIdentifier: "OfflineController") as! OfflineController
            
            
            
            switch status {
            case .unknown, .offline:
                self.present(neworVc, animated: true, completion: nil)
                
            case .online(.wwan):
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                let pm = placemarks![0]
               
                
                if pm.subLocality != nil {
                self.addressString = self.addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                self.addressString = self.addressString + pm.locality!  + ", "
                }
                if pm.locality != nil {
                    self.addressString = self.addressString + pm.administrativeArea! + ", "
                }
                if pm.country != nil {
                self.addressString = self.addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                self.addressString = self.addressString + pm.postalCode! + " "
                }
                   
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        if self.addressString != "" {
                                let story = UIStoryboard(name: "Main", bundle: nil)
                                let homeVC = story.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                            cityname = self.addressString
                                homeVC.modalPresentationStyle = .fullScreen
                                self.present(homeVC, animated: true, completion: nil)
                    
                            }
                        else{
                            print("not correct")
                        }
                            }
                
                print(self.addressString)
                
                 }
            case .online(.wiFi):
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                let pm = placemarks![0]
               
                
                if pm.subLocality != nil {
                self.addressString = self.addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                self.addressString = self.addressString + pm.locality!  + ", "
                }
                if pm.locality != nil {
                    self.addressString = self.addressString + pm.administrativeArea! + ", "
                }
                if pm.country != nil {
                self.addressString = self.addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                self.addressString = self.addressString + pm.postalCode! + " "
                }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        if self.addressString != "" {
                                let story = UIStoryboard(name: "Main", bundle: nil)
                                let homeVC = story.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                            cityname = self.addressString
                                homeVC.modalPresentationStyle = .fullScreen
                               self.present(homeVC, animated: true, completion: nil)
//                            self.navigationController?.pushViewController(homeVC, animated: true)
                    
                            }
                        else{
                            print("not correct")
                        }
                            }
                
                print(self.addressString)
                
                 }
            }
        
    
        }

        
       
    }
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            if status == "Offline" {
                let story = UIStoryboard(name: "Main", bundle: nil)
                let neworVc = story.instantiateViewController(withIdentifier: "OfflineController") as! OfflineController
                self.present(neworVc, animated: true, completion: nil)
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)

    }
    func loadgifImage() {
        let jeremyGif = UIImage.gifImageWithName("location")
        let imageView = UIImageView(image: jeremyGif)
        imageView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height:self.contentView.frame.height)
         imageView.animationImages = jeremyGif?.images
         imageView.animationRepeatCount = 5
         self.contentView.addSubview(imageView)
         
    }
    
    @IBAction func setLocation(_ sender: Any) {
        let status = CLLocationManager.authorizationStatus()
       
           switch status {
               // 1
           case .notDetermined:
                   locationManager.requestWhenInUseAuthorization()
                  // return

               // 2
           case .denied, .restricted:
               let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               alert.addAction(okAction)

               present(alert, animated: true, completion: nil)
               return
           case .authorizedAlways, .authorizedWhenInUse:
               break
            
           

           @unknown default:
            fatalError()
           }

           // 4
           locationManager.delegate = self
           locationManager.startUpdatingLocation()
    }
    
    @IBAction func enterManually(_ sender: Any) {
        var chooseLocCon = ChooseLocationController()
          chooseLocCon = self.storyboard?.instantiateViewController(withIdentifier: "ChooseLocationController") as! ChooseLocationController
          self.navigationController?.pushViewController(chooseLocCon, animated: true)
    }
}
