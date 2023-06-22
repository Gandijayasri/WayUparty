//
//  LoginController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 01/10/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import AnimatedField
import AwaitToast
import GoogleSignIn
import Alamofire

var userEmail:String = ""
var userMobile:String = ""
class LoginController: UIViewController {
    var passwordChanged:Bool = false
    var signUPDone:Bool = false
    var vendorId = String()
    var timeSlotsArray = Array<String>()
    var datesArray = Array<String>()
    var masterServiceUUID = String()
    var passableDates = Array<String>()
    var guestsAllowed = Int()
    var imgUrl = String()
    var price = Double()
    var bottleName = String()
    var serviceType = String()
    var itemsOffered = NSArray()
    var menuItem = NSArray()
    var menuItemUUID = NSArray()
    var menuItemsList = NSArray()
    var packageName = String()
    var discountType = Array<String>()
    var getServicesListModel:GetServicesListModel!
    @IBOutlet weak var registerNewUserBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var userNameTxtField: UITextField!
    
    @IBOutlet weak var transpereantImgVw: UIImageView!
    
    @IBOutlet weak var backVw: UIView!
    
    var navCon = UINavigationController()
    var type = String()
    var isScreenTypeReusableResCon: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginBtn.addTarget(self, action: #selector(loginActionClicked), for: .touchUpInside)
        // Do any additional setup after loading the view.
        self.registerNewUserBtn.addTarget(self, action: #selector(SignUpActionClicked), for: .touchUpInside)
        self.loginBtn.layer.cornerRadius = 10
        self.registerNewUserBtn.layer.cornerRadius = 10
        userNameTxtField.attributedPlaceholder = NSAttributedString(string: " Email",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTxtField.attributedPlaceholder = NSAttributedString(string: " Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        userNameTxtField.delegate = self
        passwordTxtField.delegate = self
        SetUpUIElements()
    }
    func SetUpUIElements(){
        transpereantImgVw.layer.cornerRadius = 15
        transpereantImgVw.clipsToBounds = true
        backVw.layer.cornerRadius = 15
        backVw.clipsToBounds = true
        loginBtn.layer.cornerRadius = 20
        
    }
    
    func senddetailstoserver(firstname:String,lastname:String,emailid:String)  {
        let constants = Constants()
        let url = "https://wayuparty.com/ws/saveGoogleUserRegistration?loginUserName=\(firstname)&email=\(emailid)&mobile=1111111111&password=\(emailid)&confirmPassword=\(emailid)&registrationType=GOOGLE&terms=on"
        
         AF.request(url, method: .post, parameters:nil)
            .responseJSON { response in

                print(response)

                do{
                    let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: []) as? NSDictionary ?? [:]
                    let response = jsonResult["response"] as? String
                    let datadict = jsonResult["object"] as? NSDictionary ?? nil
                    var userid = ""

                    if datadict != nil{
                        userid = datadict?["userUUID"] as? String ?? ""
                        UserDefaults.standard.set(userid , forKey: "userUUID")
                    }



                    if response == "SUCCESS" {

                        self.showToastatbottom(message: "Registration Sucess Verify your Mail Id")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            if userid != nil {
                                self.tabBarController?.selectedIndex = 0
                            }
                        }
                    }
                    else{
                        self.showToastatbottom(message:"User already Exists Please Login")
                    }


                }
                catch{

                }
            }
        
    }
    
    
    @IBAction func gmailSignin(_ sender: UIButton) {
        let signInConfig = GIDConfiguration.init(clientID: "259434588508-t0i4nc6ttlochjhpanh7ij009qlksh0b.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = signInConfig
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
                     if let error = error {
                        print(error)
                        }
                        guard let user = signInResult?.user,
                        let idToken = user.idToken else { return }
                         let accessToken = user.accessToken
                        let fullname = user.profile?.name ?? ""
                        let user_id = user.userID ?? ""
                        let emailid = user.profile?.email ?? ""
            
                        let fullnamArr = fullname.components(separatedBy: "")
                        var fname = ""
                        var lname = ""
                        if fullnamArr.count > 1{
                            fname = fullnamArr[0]
                            lname = fullnamArr[1]
                        }else{
                            fname = fullnamArr[0]
                            lname = ""
                        }
                             
                print("googleresults\(user.profile?.name),\(user.profile?.email)\(user.profile?.givenName),\(user.profile?.familyName)")
            
            
            DispatchQueue.main.async {
                let finalname = fullname.removingWhitespaces()
                
                self.senddetailstoserver(firstname: finalname , lastname: lname ?? "", emailid: emailid)
                
                       }
          }


        
}
    
   
    @objc func loginActionClicked(){
        self.loadingIndicator()
        var pickDateCon = PickDateAndTimeController()
        pickDateCon = self.storyboard?.instantiateViewController(withIdentifier: "PickDateAndTimeController") as! PickDateAndTimeController
        let userData = ["userName":self.userNameTxtField.text ?? String (), "password":self.passwordTxtField.text ?? String()]
        LoginModelParser.GetUserLoginDetails(userData: userData){(responce) in
            let message = responce.loginModel.first?.response ?? String()
            userEmail = responce.loginModel.first?.userEmail ?? String()
            userMobile = responce.loginModel.first?.userMobile ?? String()
            UserDefaults.standard.set(true, forKey: "login")
            if message == "SUCCESS"{
               
                UserDefaults.standard.setValue(self.passwordTxtField.text ?? String(), forKey: "Passw")
               UserDefaults.standard.set(responce.loginModel.first?.userUUID ?? String(), forKey: "userUUID")
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["userUUID":"Dadhaniya"])
                UserDefaults.standard.setValue(responce.loginModel.first?.userImage ?? String(), forKey: "userImage")
                UserDefaults.standard.setValue(responce.loginModel.first?.loginUserName ?? String(), forKey: "loginUserName")
                UserDefaults.standard.setValue(responce.loginModel.first?.dob ?? String(), forKey: "dob")
                UserDefaults.standard.set(responce.loginModel.first?.userEmail ?? String(), forKey: "userEmail")
                UserDefaults.standard.set(responce.loginModel.first?.userMobile ?? String(), forKey: "userMobile")
                UserDefaults.standard.set(responce.loginModel.first?.preferredDrinksList ?? Array<String>(), forKey: "preferredDrinksList")
                UserDefaults.standard.set(responce.loginModel.first?.preferredMusicList ?? Array<String>(), forKey: "preferredMusicList")
                UserDefaults.standard.set(responce.loginModel.first?.gender ?? String(), forKey: "gender")
                UserDefaults.standard.set(responce.loginModel.first?.preferredDrinks ?? String(), forKey: "preferredDrinks")
                UserDefaults.standard.set(responce.loginModel.first?.preferredMusic ?? String(), forKey: "preferredMusic")
                UserDefaults.standard.setValue(responce.loginModel.first?.userImage ?? String(), forKey: "userImage")
                if self.isScreenTypeReusableResCon == true{
                    pickDateCon.getServicesListModel = self.getServicesListModel
                    pickDateCon.timeSlotsArray = self.timeSlotsArray
                    pickDateCon.passableDates = self.passableDates
                    pickDateCon.timeSlotsArray = self.timeSlotsArray
                    pickDateCon.datesArray = self.datesArray
                    pickDateCon.imgUrl = self.imgUrl
                    pickDateCon.bottleName = self.bottleName
                    pickDateCon.price = self.price
                    pickDateCon.vendorId = self.vendorId
                    pickDateCon.masterServiceUUID = self.masterServiceUUID
                    pickDateCon.guestsAllowed = self.guestsAllowed
                    pickDateCon.type = self.type
                    if self.serviceType == "The WayU Party"{
                      pickDateCon.serviceType = "The WayU Party"
                      pickDateCon.itemsOffered = self.itemsOffered
                      pickDateCon.menuItemUUID = self.menuItemUUID
                      pickDateCon.menuItem = self.menuItem
                      pickDateCon.menuItemsList = self.menuItemsList
                      pickDateCon.packageName = self.packageName
                  }
                  DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                  self.dismiss(animated: true){
                      self.navCon.pushViewController(pickDateCon, animated: true)
                    }
                  }
                }else{
                    DispatchQueue.main.async{
                        userName = self.userNameTxtField.text ?? String ()
                        password = self.passwordTxtField.text ?? String()
                        print(userName)
                        print(password)
                        UserDefaults.standard.set(userName, forKey: "userName")
                        UserDefaults.standard.setValue(password, forKey: "password")
                        if self.passwordChanged == true || self.signUPDone == true{
                            self.dismiss(animated:true){
                                let toast = Toast.default(text: "Logged In Successfully", direction: .top)
                                toast.show()
                            }
                        }
                        else{
                            self.dismiss(animated:true , completion: nil)
                        }
                    }
                }
            }else{
                isAnimationFalse = true
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: "\(responce.loginModel.first?.responseMessage ?? "Object not intialized")", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func forgotPasswordActionEvent(_ sender: UIButton) {
        var forgotPasswordCon = ForgotPasswordController()
        forgotPasswordCon = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordController") as! ForgotPasswordController
        forgotPasswordCon.navCon = self.navCon
        forgotPasswordCon.isScreenTypeReusableResCon = self.isScreenTypeReusableResCon
    self.dismiss(animated: true){
        self.navCon.present(forgotPasswordCon, animated: true, completion: nil)
        }
    }
    
    @objc func SignUpActionClicked(){
        self.dismiss(animated: true){
            var signUpCon = SignUpController()
            signUpCon = self.storyboard?.instantiateViewController(withIdentifier: "SignUpController") as! SignUpController
            signUpCon.navCon = self.navCon
            signUpCon.isScreenTypeReusableResCon = self.isScreenTypeReusableResCon
                self.navCon.present(signUpCon, animated: true, completion:nil)
        }
    }

}
extension LoginController: AnimatedFieldDataSource {
    func animatedFieldLimit(_ animatedField: AnimatedField) -> Int? {
        switch animatedField.tag {
        case 1: return 10
        case 8: return 30
        default: return nil
     }
  }
    
    func loadingIndicator(){
        isAnimationFalse = false
        var loadingSupport = LoadingSupport()
        loadingSupport = self.storyboard?.instantiateViewController(withIdentifier: "LoadingSupport") as! LoadingSupport
        addChild(loadingSupport)
        self.view.addSubview(loadingSupport.view)
    }
    
    func animatedFieldValidationError(_ animatedField: AnimatedField) -> String? {
        if animatedField  == userNameTxtField {
            return "username invalid! Please check again ;)"
        }
        return nil
    }
}

extension LoginController: AnimatedFieldDelegate {
    func animatedField(_ animatedField: AnimatedField, didSecureText secure: Bool) {
        if animatedField == passwordTxtField {
            //passwordTxtField.secureField(secure)
        }
    }
    
    func animatedFieldDidChange(_ animatedField: AnimatedField) {
        print("text: \(animatedField.text ?? "")")
    }
    
    func animatedFieldShouldReturn(_ animatedField: AnimatedField) -> Bool {
        // Optional
        view.endEditing(true)
        return true
    }
}

extension LoginController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
