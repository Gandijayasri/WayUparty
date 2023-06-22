//
//  SubmitCodeController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 24/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import AwaitToast
class SubmitCodeController: UIViewController,UITextFieldDelegate {
    var verficationUUID = String()
    var isScreenTypeReusableResCon: Bool = false
    var navCon = UINavigationController()
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    @IBOutlet weak var verficationCodeTxtField: UITextField!
    
    @IBOutlet weak var creatBtn: UIButton!
    
    @IBOutlet weak var forgotBtn: UIButton!
    
    @IBOutlet weak var transperentVw: UIImageView!
    
    @IBOutlet weak var backVw: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTxtField.attributedPlaceholder = NSAttributedString(string: " Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        confirmPasswordTxtField.attributedPlaceholder = NSAttributedString(string: " Confirm Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        verficationCodeTxtField.attributedPlaceholder = NSAttributedString(string: " Verification Code",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        // Do any additional setup after loading the view.
        
        passwordTxtField.delegate = self
        confirmPasswordTxtField.delegate = self
        verficationCodeTxtField.delegate = self
        SetUIElements()
    }
   // ForgotPasswordController
    func SetUIElements()  {
        backVw.layer.cornerRadius = 15
        transperentVw.layer.cornerRadius = 15
        creatBtn.layer.cornerRadius = 20
       forgotBtn.addTarget(self, action: #selector(forgotActionClicked), for: .touchUpInside)
        
    }
    @objc func forgotActionClicked(){
        self.dismiss(animated: true){
            var loginCon = ForgotPasswordController()
            loginCon = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordController") as! ForgotPasswordController
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
    
    @IBAction func submitActionEvent(_ sender: UIButton) {
        let verificationData = ["verificationUUID":self.verficationUUID,"verificationCode":self.verficationCodeTxtField.text ?? String(),"password":self.passwordTxtField.text ??  "noPwd","confirmPassword":self.confirmPasswordTxtField.text ?? "noCnfrmPwd"]
        self.loadingIndicator()
        SubmitCodeModelParser.SubmitCodeAPI(verificationData: verificationData){(responce) in
            if responce.submitCodeModel.first?.response == "SUCCESS"{
                isAnimationFalse = true
                DispatchQueue.main.async {
                self.dismiss(animated: true){
                    var loginCon = LoginController()
                    loginCon = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                    loginCon.navCon = self.navCon
                    loginCon.passwordChanged = true
                    self.navCon.present(loginCon, animated: true){
                        let toast = Toast.default(text: "Password changed Successfully", direction: .top)
                        toast.show()
                    }
                }
            }
        }
            else{
                isAnimationFalse = true
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: "\(responce.submitCodeModel.first?.responseMessage ?? "Object not intialized")", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
}

extension SubmitCodeController{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
