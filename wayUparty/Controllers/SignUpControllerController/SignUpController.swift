//
//  SignUpController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 24/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import AwaitToast

class SignUpController: UIViewController {
    @IBOutlet weak var confirmTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var mobileTxtFiled: UITextField!{
        didSet {
            mobileTxtFiled?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var dobTxtFeild: UITextField!
    var isScreenTypeReusableResCon: Bool = false
    var timer:Timer?
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    
    @IBOutlet weak var backVw: UIView!
    @IBOutlet weak var transperImg: UIImageView!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var navCon = UINavigationController()
    var gender = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupElements()
        nameTxtField.attributedPlaceholder = NSAttributedString(string: " Name",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTxtField.attributedPlaceholder = NSAttributedString(string: " Email",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        mobileTxtFiled.attributedPlaceholder = NSAttributedString(string: " Mobile",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTxtField.attributedPlaceholder = NSAttributedString(string: " Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        confirmTxtField.attributedPlaceholder = NSAttributedString(string: " Confirm Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        dobTxtFeild.attributedPlaceholder = NSAttributedString(string: "Date of Birth",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.nameTxtField.delegate = self
        self.emailTxtField.delegate = self
        self.passwordTxtField.delegate = self
        self.mobileTxtFiled.delegate = self
        self.confirmTxtField.delegate = self
        self.dobTxtFeild.delegate = self
        if self.gender != ""{
            if self.gender == "Male"{self.maleBtn.isSelected = true;self.gender="Male"}
            if self.gender == "Female"{self.femaleBtn.isSelected = true;self.gender="Female"}
        }
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(assignObjectToTextFeild), userInfo: nil, repeats: true)
    }
    
    @objc func assignObjectToTextFeild(){
        dobTxtFeild.text = signUpDOB
        dobTxtFeild.resignFirstResponder()
    }
    
    @IBAction func maleBtnClicked(_ sender: UIButton) {
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
            femaleBtn.isSelected = false
        }
        gender = "Male"
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else{return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else{return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0{
            self.navigationController?.navigationBar.isHidden = true
            self.view.frame.origin.y -= keyboardFrame.height - 40
            print(keyboardFrame.height - self.view.frame.origin.y)
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.navigationController?.navigationBar.isHidden = false
            self.view.frame.origin.y = 0
            
        }
    }
    
    @IBAction func femaleBtnClicked(_ sender: UIButton) {
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
            maleBtn.isSelected = false
        }
        gender = "Female"
    }
    func SetupElements(){
        transperImg.layer.cornerRadius = 15
        backVw.layer.cornerRadius = 15
        signUpBtn.layer.cornerRadius = 20
        signInBtn.addTarget(self, action: #selector(SigninActionClicked), for: .touchUpInside)
        }
    @objc func SigninActionClicked(){
        self.dismiss(animated: true){
            var loginCon = LoginController()
            loginCon = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            loginCon.navCon = self.navCon
            loginCon.isScreenTypeReusableResCon = self.isScreenTypeReusableResCon
                self.navCon.present(loginCon, animated: true, completion:nil)
        }
    }
    func loadingIndicator(){
        isAnimationFalse = false
        var loadingSupport = LoadingSupport()
        loadingSupport = self.storyboard?.instantiateViewController(withIdentifier: "LoadingSupport") as! LoadingSupport
        addChild(loadingSupport)
        self.view.addSubview(loadingSupport.view)
    }
    
    @IBAction func signUpActionEvent(_ sender: UIButton) {
        let userData = ["loginUserName":self.nameTxtField.text ?? String(),"email":self.emailTxtField.text ?? String(),"mobile":self.mobileTxtFiled.text ?? String(),"password":self.passwordTxtField.text ?? String(),"gender":self.gender,"dob":self.dobTxtFeild.text ?? String(),"confirmPassword":self.confirmTxtField.text ?? String(),"registrationType":"WAYUPARTY"]
        self.loadingIndicator()
        SignUpModelParser.SignUPAPI(userData: userData){(responce) in
            if responce.loginModel.first?.response == "SUCCESS"{
                isAnimationFalse = true
                DispatchQueue.main.async {
                    self.dismiss(animated: true){
                        var loginCon = LoginController()
                        loginCon = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                        loginCon.signUPDone = true
                        self.navCon.present(loginCon, animated: true){
                            let toast = Toast.default(text: "Please verify your email before logging in", direction: .top)
                            toast.show()
                        }
                    }
                }
            }
            else{
                isAnimationFalse = true
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: "\(responce.loginModel.first?.response ?? "Object not intialized")", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
}

extension SignUpController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.view.frame.origin.y == 0{
            self.navigationController?.navigationBar.isHidden = true
            self.view.frame.origin.y -= 88+44 - 40
            print(88+44 - self.view.frame.origin.y)
        }
        if textField == self.passwordTxtField || textField == self.confirmTxtField{
            if self.view.frame.origin.y != 0{}
            else{self.view.frame.origin.y -=  60}
        }
        if textField == dobTxtFeild{
            var child = DatePickerViewController()
            child = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
            addChild(child)
            view.addSubview(child.view)
            child.didMove(toParent: self)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.view.frame.origin.y != 0{
            self.navigationController?.navigationBar.isHidden = false
            self.view.frame.origin.y = 0
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.frame.origin.y = 0
        textField.resignFirstResponder()
        return true
    }
}
