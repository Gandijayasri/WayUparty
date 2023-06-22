//
//  SelectCountryVC.swift
//  wayUparty
//
//  Created by jayasri on 18/06/23.
//  Copyright © 2023 Arun. All rights reserved.
//

import UIKit

class SelectCountryVC: UIViewController {
    
    @IBOutlet weak var viewSelectCountry: UIView!
    @IBOutlet weak var viewSelectCity: UIView!
    @IBOutlet weak var lblCountry:UILabel!
    @IBOutlet weak var lblCity:UILabel!

    var countrysDataList: CountryModel?
    var citysDataList: CityModel?
    var selectedCountryID = 101110


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView?.isHidden = false
       

        viewSelectCountry.layer.cornerRadius = 15
        viewSelectCountry.layer.borderWidth = 1
        viewSelectCountry.layer.borderColor = UIColor.systemYellow.cgColor

        viewSelectCity.layer.cornerRadius = 15
        viewSelectCity.layer.borderWidth = 1
        viewSelectCity.layer.borderColor = UIColor.systemYellow.cgColor
        CountryDataAPI()
    }
    
    
   
    @IBAction func selectCountryTapped(_ sender:UIButton) {
        
       
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryCityPopupVC") as? CountryCityPopupVC {
            vc.modalPresentationStyle = .overCurrentContext
            vc.countrysDataList = countrysDataList
            vc.delegate = self
            vc.isCountry = true
            self.present(vc, animated: false)
        }
       
        
    }

    
    @IBAction func selectCityTapped(_ sender:UIButton) {
        
        if lblCountry.text == "Select Country"{
            showToastatbottom(message: "Please Select Country First")
        }else{
            CityDataAPI(countriesId:selectedCountryID)

        }
        
    }

}

extension SelectCountryVC {
    
    func CountryDataAPI() {
        
        NetworkAdaptor.request(url: "https://wayuparty.com/ws/getPopularCountries", method: .get) { data , response , error in
            
            if let error = error{
                print(error.localizedDescription)
            }else{
                if let data = data{
                    do{
                        let jsonData = try JSONDecoder().decode(CountryModel.self, from: data)
                        print(jsonData)
                        self.countrysDataList = jsonData
                        
                        
                    }catch{
                        print(error.localizedDescription)
                        
                    }
                }
                
            }
        }
        
    }
    
    func CityDataAPI(countriesId:Int) {
        
        NetworkAdaptor.request(url: "https://wayuparty.com/ws/getPopularCities?=&countryId=\(countriesId)", method: .get) { data , response , error in
            
            if let error = error{
                print(error.localizedDescription)
            }else{
                if let data = data{
                    do{
                        let jsonData = try JSONDecoder().decode(CityModel.self, from: data)
                        print(jsonData)
                        self.citysDataList = jsonData
                        DispatchQueue.main.async {
                            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryCityPopupVC") as? CountryCityPopupVC {
                                vc.modalPresentationStyle = .overCurrentContext
                                vc.citysDataList = self.citysDataList
                                vc.delegate = self
                                vc.isCountry = false
                                self.present(vc, animated: false)
                            }
                        }
                        
                    }catch{
                        print(error.localizedDescription)
                        
                    }
                }
                
            }
        }
        
    }
}



extension SelectCountryVC : CountryCityPopupVCDelegate{
    func countrySelected(id: Int,index:Int) {
        selectedCountryID = id
        lblCountry.text = countrysDataList?.data?[index].countryName
    }
    
    func citySelected(id: String,index:Int) {
        lblCity.text = citysDataList?.data?[index].cityName
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = story.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
        homeVC.modalPresentationStyle = .fullScreen
        lat = self.citysDataList?.data?[index].latitude ?? ""
        lng = self.citysDataList?.data?[index].longitude ?? ""
        cityname = self.citysDataList?.data?[index].cityName ?? ""
        dealsAndOffersOn = false
        //self.present(homeVC, animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        Screen_navgation = 1
    }
    
   
    
    
}
