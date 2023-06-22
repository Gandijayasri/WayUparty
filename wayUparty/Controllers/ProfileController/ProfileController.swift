//
//  ProfileController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 14/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import MessageUI
import Kingfisher
import MarqueeLabel

class ProfileController: UIViewController{
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var loginBtn: UIButton!
    var timer : Timer?
    @IBOutlet weak var loginHidenView:UIView!
    
    @IBOutlet var chatBtn: UIButton!
    
    @IBOutlet var supportView: UIView!
    @IBOutlet var mailBtn: UIButton!
    @IBOutlet var phoneBtn: UIButton!
    
   
    @IBOutlet weak var topspendLbl: MarqueeLabel!
    var topspendList:TopSpendingModel! = nil
   
    let imageCache = NSCache<AnyObject, AnyObject>()
    var preferedMusicHeight = CGFloat()
    var preferedDrinkHeight = CGFloat()
    var drinkPickerValues = Array<String>()
    var musicPickerValues = Array<String>()
    var logoutBtn = UIBarButtonItem()
    var optionsMenu: CAPSOptionsMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        chatBtn.layer.cornerRadius = 10
        mailBtn.layer.cornerRadius = 10
        phoneBtn.layer.cornerRadius = 10
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String
        userName = UserDefaults.standard.object(forKey: "userName") as? String ?? ""
       
        //setUpNavigationBarItems()
        addLeftBarbtnIcon(named: "logo_Icon")
        self.loginBtn.layer.cornerRadius = 20
        self.loginBtn.layer.borderWidth = 1.0
        self.loginBtn.layer.borderColor = UIColor.init(red: 186.0/255.0, green: 153.0/255.0, blue: 96.0/255.0, alpha: 1.0).cgColor
        
        
        if  userUUID == nil{
            self.loginHidenView.isHidden = false
            self.startTimer()
        }else{
            self.startTimer()
            self.loginHidenView.isHidden = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("userUUid"), object: nil)
       
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        threeDotMenu()
    }
    
  
    @IBAction func chatAction(_ sender: UIButton) {
      //  Freshchat.sharedInstance().showConversations(self)
        
    }
   
    @IBAction func contactNumAct(_ sender: UIButton) {
        print("test")
        callNumber(phoneNumber: "08663452146")
    }
    
    @IBAction func sendMail(_ sender: UIButton) {
       showMailComposer()
    }
    
    func showMailComposer() {
        
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing the user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["contact@wayuparty.com"])
        composer.setSubject("HELP!")
        composer.setMessageBody("Orderrelated Query!", isHTML: false)
        
        present(composer, animated: true)
    }
    /*Contact Number**/
    private func callNumber(phoneNumber:String) {

        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {

            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                     application.openURL(phoneCallURL as URL)

                }
            }
        }
    }
    /*Mail Support*/
    
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        threeDotMenu()
     
    }
    func threeDotMenu()  {
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String
        print("user\(String(describing: userUUID))")
        
        if userUUID != nil{
            let image = UIImage(named: "more.png")
            image?.withTintColor(UIColor.white)
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            optionsMenu = CAPSOptionsMenu(viewController: self, image:image!, keepBarButtonAtEdge: true)
            optionsMenu?.menuActionButtonsHighlightedColor(color: UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0))
            optionsMenu?.menuCornerRadius = 2.0
           
            let menuAction1: CAPSOptionsMenuAction = CAPSOptionsMenuAction(title: "Privicy Policy") { (action: CAPSOptionsMenuAction) -> Void in
                let story = UIStoryboard(name: "Main", bundle: nil)
                let privacyVc = story.instantiateViewController(withIdentifier: "PrivacyController") as! PrivacyController
                privacyVc.modalPresentationStyle = .fullScreen
                self.present(privacyVc, animated: true, completion: nil)
                
                
            }
            
            optionsMenu?.addAction(action: menuAction1)
            
            let menuAction2: CAPSOptionsMenuAction = CAPSOptionsMenuAction(title: "Terms&Conditions") { (action: CAPSOptionsMenuAction) -> Void in
                let story = UIStoryboard(name: "Main", bundle: nil)
                let termsVc = story.instantiateViewController(withIdentifier: "TermsController") as! TermsController
                termsVc.modalPresentationStyle = .fullScreen
                self.present(termsVc, animated: true, completion: nil)
            }
            optionsMenu?.addAction(action: menuAction2)
            
            let menuAction3: CAPSOptionsMenuAction = CAPSOptionsMenuAction(title: "Logout") { (action: CAPSOptionsMenuAction) -> Void in
                print("Tapped Action Button 3")
                self.powerAction()
            }
            optionsMenu?.addAction(action: menuAction3)
            supportView.isHidden = false
        }
        else{
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem = .none
            }
            
        }
    }

    func powerAction(){
        let alertController = UIAlertController(title: "Message", message: "Do you want to logout from curent profile", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Logout", style: UIAlertAction.Style.default) {
                UIAlertAction in
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
            UserDefaults.standard.removeObject(forKey: "userUUID")
            self.navigationItem.rightBarButtonItem = nil
            let alertController = UIAlertController(title: "Message", message: "Logged Out Successfully", preferredStyle: .alert)
        let okAction = UIKit.UIAlertAction(title: "OK", style: UIKit.UIAlertAction.Style.default) {
              UIAlertAction in
            let story = UIStoryboard(name: "Main", bundle: nil)
            let agreeVC = story.instantiateViewController(withIdentifier: "Agerestriction") as! Agerestriction
            let navigationController = UINavigationController(rootViewController: agreeVC)
            UIApplication.shared.windows.first?.rootViewController = navigationController
           UIApplication.shared.windows.first?.makeKeyAndVisible()
            
            
            
          }
          alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                UIAlertAction in}
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
//    func setUpNavigationBarItems(){
//        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "list"), style: .plain, target: self, action: #selector(leftBarButtonItemAction))
//        leftBarButtonItem.tintColor = UIColor.init(red: 186.0/255.0, green: 156.0/255.0, blue: 93.0/255.0, alpha: 1.0)
//        self.navigationItem.leftBarButtonItem = leftBarButtonItem
//    }
//
//
//    @objc func leftBarButtonItemAction(){
//        self.view.endEditing(true)
//        self.slideMenuViewController().showLeftMenu(true)
//    }
//
    
    @objc func loginAction(_sender:UIButton){
        var loginCon = LoginController()
        loginCon = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        loginCon.navCon = self.navigationController!
        //loginCon.modalPresentationStyle = .fullScreen
        self.navigationController?.present(loginCon, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        topspendingList()
        //userEmail
        self.tabBarController?.tabBar.isHidden = false
        
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String
        print("user_id:--->\(userUUID)")
        if  userUUID == nil{
            self.loginHidenView.isHidden = false
            supportView.isHidden = true
            self.startTimer()
            self.navigationItem.rightBarButtonItem = .none
        }else{
            self.startTimer()
            self.loginHidenView.isHidden = false
            supportView.isHidden = false
         
            
        }
        
       
        // Do any additional setup after loading the view.
       self.loginBtn.addTarget(self, action: #selector(self.loginAction), for: .touchUpInside)
       userName = UserDefaults.standard.object(forKey: "userName") as? String ?? "N/A"
       password =  UserDefaults.standard.object(forKey: "password") as? String ?? "N/A"
        print(userName)
        print(password)
       
        let userData = ["userName":userName, "password":password]
        LoginModelParser.GetUserLoginDetails(userData: userData){(responce) in
            DispatchQueue.main.async {
                
                UserDefaults.standard.setValue(responce.loginModel.first?.userImage ?? String(), forKey: "userImage")
                print(responce.loginModel.first?.userImage ?? String())
                let musicList = UserDefaults.standard.object(forKey: "preferredMusic") as? String ?? "N/A"
                self.musicPickerValues = musicList.components(separatedBy: ",")
                let drinkList = UserDefaults.standard.object(forKey: "preferredDrinks") as? String
                self.drinkPickerValues = drinkList?.components(separatedBy: ",") ?? []
                self.preferedMusicHeight = self.heightForView(text: musicList , font: UIFont.systemFont(ofSize: 13), width: UIScreen.main.bounds.size.width-12)
                self.preferedDrinkHeight = self.heightForView(text: drinkList ?? "N/A", font: UIFont.systemFont(ofSize: 13), width: UIScreen.main.bounds.size.width-12)
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("userUUid"), object: nil)
    }
    
    func startTimer()
    {
      if timer == nil {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(setUserProfile), userInfo: nil, repeats: true)
      }
    }
    
    @objc func setUserProfile(){
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String
        if  userUUID == nil{
            self.loginHidenView.isHidden = false
            supportView.isHidden = true
            stopTimer()
        }else{
            self.loginHidenView.isHidden = true
            supportView.isHidden = false
            stopTimer()
        }
    }
    
    func stopTimer()
    {
//      if timer != nil {
//        timer!.invalidate()
//        timer = nil
        let musicList = UserDefaults.standard.object(forKey: "preferredMusic") as? String ?? "N/A"
        self.musicPickerValues = musicList.components(separatedBy: ",")
        let drinkList = UserDefaults.standard.object(forKey: "preferredDrinks") as? String
        self.drinkPickerValues = drinkList?.components(separatedBy: ",") ?? []
        preferedMusicHeight = self.heightForView(text: drinkList ?? "N/A", font: UIFont.systemFont(ofSize: 13), width: UIScreen.main.bounds.size.width-12)
        preferedDrinkHeight = self.heightForView(text: musicList, font: UIFont.systemFont(ofSize: 13), width: UIScreen.main.bounds.size.width-12)
            loginBtn.layer.cornerRadius = 20
            loginBtn.layer.borderWidth = 1.0
            loginBtn.layer.borderColor = UIColor.init(red: 186.0/255.0, green: 153.0/255.0, blue: 96.0/255.0, alpha: 1.0).cgColor
        self.tableView.reloadData()
     // }
    }
    
}
class ProfilePicCell:UITableViewCell{
    @IBOutlet weak var profileImageView:UIImageView!
    @IBOutlet weak var editBtn:UIButton!
    @IBOutlet weak var emailLbl:UILabel!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    
}

extension ProfileController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePicCell") as! ProfilePicCell
        let email = UserDefaults.standard.object(forKey: "userEmail") as? String ?? "N/A"
        cell.emailLbl.text = email
         let name = UserDefaults.standard.object(forKey: "loginUserName") as? String ?? "N/A"
         cell.nameLbl.text = name
            
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height / 2.0
        cell.profileImageView.layer.borderWidth = 5.0
        cell.profileImageView.layer.borderColor = UIColor.white.cgColor
        let constants = Constants()
        let profileimgUrl = UserDefaults.standard.object(forKey: "userImage") as? String ?? ""
            
            if let url = URL(string: constants.baseUrl+profileimgUrl){
            
            let resource = ImageResource(downloadURL: url)
                KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                       
                        cell.profileImageView.image = value.image.resizeWith(percentage: 0.25)
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
              
       
        cell.profileImageView.layer.masksToBounds = true
        cell.editBtn.addTarget(self, action: #selector(editProfileTocuhEvent), for: .touchUpInside)
        return cell
       
        case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileDateOfBirthCell") as! UserProfileDateOfBirthCell
        let dob = UserDefaults.standard.object(forKey: "dob") as? String ?? "N/A"
        cell.dateOfBirthLbl.text = dob
            let mobile = UserDefaults.standard.object(forKey: "userMobile") as? String ?? "N/A"
            cell.mobileLbl.text = mobile
            let musicList = UserDefaults.standard.object(forKey: "preferredMusic") as? String ?? "N/A"
            cell.prefferedMusicLbl.text = musicList
            let drinkList = UserDefaults.standard.object(forKey: "preferredDrinks") as? String ?? "N/A"
            cell.prefferedDrinksLbl.text = drinkList
        return cell
       
        default:
        return UITableViewCell()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
        return 237
        case 1:
        return 240
       default:
            return 240
        }
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 6{
//            var guestRestCon = GuestListRestuarentsController()
//            guestRestCon = self.storyboard?.instantiateViewController(identifier: "GuestListRestuarentsController") as! GuestListRestuarentsController
//            self.navigationController?.pushViewController(guestRestCon, animated: true)
//        }
//    }
    
    @objc func editProfileTocuhEvent(_ sender:UIButton){
        let dob = UserDefaults.standard.object(forKey: "dob") as? String ?? "N/A"
        var profileDetailsCon = ProfileDetails()
        profileDetailsCon = self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetails") as! ProfileDetails
        profileDetailsCon.musicPickerValues = self.musicPickerValues
        profileDetailsCon.drinkPickerValues = self.drinkPickerValues
        dobOfUser = dob
        print(self.musicPickerValues)
        print(self.drinkPickerValues)
        self.navigationController?.pushViewController(profileDetailsCon, animated: true)
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 13, y: 38, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}


class UserProfileDateOfBirthCell:UITableViewCell{
    @IBOutlet weak var dateOfBirthLbl:UILabel!
    @IBOutlet weak var mobileLbl:UILabel!
    @IBOutlet weak var prefferedMusicLbl:UILabel!
    @IBOutlet weak var prefferedDrinksLbl:UILabel!
}

extension ProfileController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            //Show error alert
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        @unknown default:
            break
        }
        
        controller.dismiss(animated: true)
    }
}

extension ProfileController{
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
