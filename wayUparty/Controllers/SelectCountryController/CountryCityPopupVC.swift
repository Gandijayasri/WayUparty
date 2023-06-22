//
//  CountryCityPopupVC.swift
//  wayUparty
//
//  Created by pampana ajay on 21/06/23.
//  Copyright © 2023 Arun. All rights reserved.
//

import UIKit

protocol CountryCityPopupVCDelegate:AnyObject{
    func countrySelected(id:Int,index:Int)
    func citySelected(id:String,index:Int)
    
}

class CountryCityPopupVC: UIViewController {
    
    @IBOutlet weak var viewBack:UIView!
    @IBOutlet weak var lblSelectCountry:UILabel!
    @IBOutlet weak var tableViewList:UITableView!
    @IBOutlet weak var btnCancel:UIButton!
    weak var delegate:CountryCityPopupVCDelegate?

    var countrysDataList: CountryModel?
    var citysDataList: CityModel?
    var isCountry = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI(){
        viewBack.layer.cornerRadius = 14
        btnCancel.layer.cornerRadius = btnCancel.frame.height/2
        tableViewList.delegate = self
        tableViewList.dataSource = self
        tableViewList.register(UINib(nibName: "CountryListTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryListTableViewCell")
        if isCountry {
            lblSelectCountry.text = "Select Country"
        }else{
            lblSelectCountry.text = "Select City"
        }
    }
    
    @IBAction func cancelTapped(){
        dismiss(animated: false)
    }
    

}

extension CountryCityPopupVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isCountry{
            delegate?.countrySelected(id: countrysDataList?.data?[indexPath.row].countryID ?? 0, index: indexPath.row)
            self.dismiss(animated: false)
        }else{
            delegate?.citySelected(id: citysDataList?.data?[indexPath.row].countryID ?? "", index: indexPath.row)
            self.dismiss(animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.transform =  CGAffineTransform(translationX: 20, y:50)
        UIView.animate(withDuration: 0.4, delay: 0.05*Double(indexPath.row), options: .curveLinear) {
            cell.transform =  CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
                }
    }
}

extension CountryCityPopupVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCountry{
            return countrysDataList?.data?.count ?? 0
        }else{
            return citysDataList?.data?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableViewList.dequeueReusableCell(withIdentifier: "CountryListTableViewCell", for: indexPath) as? CountryListTableViewCell{
            
            if isCountry{
                cell.lblCountry.text = countrysDataList?.data?[indexPath.row].countryName
            }else{
                cell.lblCountry.text = citysDataList?.data?[indexPath.row].cityName
            }
        
            return cell
        }
        
    
        return UITableViewCell()
        
    }
}


extension CountryCityPopupVC {
    
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
        
        NetworkAdaptor.request(url: "https://wayuparty.com/ws/getPopularCities?=&countryId=1", method: .get) { data , response , error in
            
            if let error = error{
                print(error.localizedDescription)
            }else{
                if let data = data{
                    do{
                        let jsonData = try JSONDecoder().decode(CityModel.self, from: data)
                        print(jsonData)
                        self.citysDataList = jsonData
                        
                        
                    }catch{
                        print(error.localizedDescription)
                        
                    }
                }
                
            }
        }
        
    }
}

