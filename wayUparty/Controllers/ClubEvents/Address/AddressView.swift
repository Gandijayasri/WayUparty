//
//  AddressView.swift
//  wayUparty
//
//  Created by Arun  on 04/05/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit
import GoogleMaps

class AddressView: UIViewController {

    @IBOutlet weak var mobilenumLbl: UILabel!
    
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var cityLbl: UILabel!
    
    @IBOutlet var mapView: GMSMapView!
    let marker = GMSMarker()
    
    var mobileno:String?
    var address:String?
    var cityofrest:String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapupdate()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIElements()
    }
    func setUIElements() {
        self.mobilenumLbl.text = mobileno ?? ""
        self.addressLbl.text = address ?? ""
        self.cityLbl.text = cityofrest ?? ""
    }
    func showMarker(position: CLLocationCoordinate2D){
            marker.position = position
            marker.map = mapView
        }
    func mapupdate()  {
        let lati = Double(lat) ?? 37.36
        let longi = Double(lng) ?? -122.0
        
        let camera = GMSCameraPosition.camera(withLatitude: lati, longitude: longi, zoom: 20)
        mapView.camera = camera
        showMarker(position: camera.target)
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
}
