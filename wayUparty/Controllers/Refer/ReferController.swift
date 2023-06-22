//
//  ReferController.swift
//  wayUparty
//
//  Created by Arun on 08/02/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import MarqueeLabel

class ReferController: UIViewController {
    
    
    @IBOutlet var countryTextField: UITextField!
    
    @IBOutlet var contactsTF: UITextField!
    
    @IBOutlet weak var topspendLbl: MarqueeLabel!
    var topspendList:TopSpendingModel! = nil
    
    let countryPicker = CountryPicker()
    var namesArr = [String]()
    var phonenumArr = [String]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        addLeftBarbtnIcon(named: "logo_Icon")
        countryPicker.textField = countryTextField
        countryPicker.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        let useruuid = UserDefaults.standard.object(forKey: "userUUID") as? String ?? ""
        print("userid:------>\(useruuid)")
        topspendingList()
        
    }
    func sendInviteAPI()  {
        
    }
    
    @IBAction func chatAct(_ sender: Any) {
        //Freshchat.sharedInstance().showConversations(self)
    }
    
    @IBAction func addcontacts(_ sender: Any) {
        onClickPickContact()
        
       
        
    }
    
    @IBAction func sendInvite(_ sender: Any) {
    }
}

extension ReferController:CountryPickerDelegate{
    func didSelectCountry(country: Country) {
        print("\(country.name)\(country.phoneCode)")
    }
    
    
}






extension UIViewController{
    func addLeftBarbtnIcon(named:String) {
        
            let logoImage = UIImage.init(named: named)
            let logoImageView = UIImageView.init(image: logoImage)
            logoImageView.frame = CGRect(x:0.0,y:0.0, width:55,height:25.0)
            logoImageView.contentMode = .scaleAspectFill
            let imageItem = UIBarButtonItem.init(customView: logoImageView)
            let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 55)
            let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 25)
             heightConstraint.isActive = true
             widthConstraint.isActive = true
             navigationItem.leftBarButtonItem =  imageItem
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            logoImageView.isUserInteractionEnabled = true
            logoImageView.addGestureRecognizer(tapGestureRecognizer)
       
        
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        tabBarScreen = "home"
      
    }

}




extension ReferController: CNContactPickerDelegate{

    //MARK:- contact picker
    func onClickPickContact(){


        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey
                , CNContactPhoneNumbersKey]
        contactPicker.navigationController?.navigationItem.leftBarButtonItem = .none
        self.present(contactPicker, animated: true, completion: nil)

    }

    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contactProperty: CNContactProperty) {

    }


    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        
        for contact in contacts {
            
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value

            let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue
            let userName:String = contact.givenName
            let familyname:String = contact.familyName
            let userfullname = "\(userName) \(familyname)"
            if phonenumArr.count != 5 {
                if userfullname == ""{
                    namesArr.append(primaryPhoneNumberStr)
                }else{
                    namesArr.append(userfullname)

                }
                phonenumArr.append(primaryPhoneNumberStr)
                let namesjoined = namesArr.joined(separator: ", ")
                print("Numberof user:---->\(namesjoined) \(phonenumArr)")
                self.contactsTF.text = namesjoined
            }else{
                 showToastatbottom(message: "you have reached maximum count")
            }
            
            
            
            
            
        }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

    }
}


extension ReferController{
    func topspendingList()  {
        self.topspendLbl.isHidden = true
        TopSpendParser.getFilterList{(response) in
            self.topspendList = response.topspendList.first
//            let arraList = self.topspendList.cityName
//            let str = arraList.joined(separator: ", ")
            DispatchQueue.main.async {
                self.topspendLbl.type = .continuous
                self.topspendLbl.speed = .rate(25)
                self.topspendLbl.fadeLength = 10.0
                self.topspendLbl.leadingBuffer = 10.0
                self.topspendLbl.trailingBuffer = 10.0
               // self.topspendLbl.text = str
            }
            
        }
        
    }
}
