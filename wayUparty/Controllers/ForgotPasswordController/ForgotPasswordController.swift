//
//  ForgotPasswordController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 24/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import AwaitToast
class ForgotPasswordController: UIViewController {
    @IBOutlet weak var verifyEmailTxtField: UITextField!
    
    @IBOutlet weak var signinBtn: UIButton!
    
    @IBOutlet weak var vrifyBtn: UIButton!
    @IBOutlet weak var transperantImg: UIImageView!
    
    @IBOutlet weak var backVw: UIView!
    var navCon = UINavigationController()
    var isScreenTypeReusableResCon: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyEmailTxtField.attributedPlaceholder = NSAttributedString(string: " Verify Email",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.verifyEmailTxtField.delegate = self
        SetUIElements()
    }
    func SetUIElements()  {
        backVw.layer.cornerRadius = 15
        transperantImg.layer.cornerRadius = 15
        vrifyBtn.layer.cornerRadius = 20
        signinBtn.addTarget(self, action: #selector(SigninActionClicked), for: .touchUpInside)
        
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
    @IBAction func verifyEmailActionEvent(_ sender: UIButton) {
        self.loadingIndicator()
        ForgotPasswordParser.ForgotPasswordAPI(email: self.verifyEmailTxtField.text ?? String()){(responce) in
            if responce.forgotModel.first?.response == "SUCCESS"{
                isAnimationFalse = true
                let verficationUUID = responce.forgotModel.first?.verificationUUID
                DispatchQueue.main.async {
                    var submitCodeCon = SubmitCodeController()
                    submitCodeCon = self.storyboard?.instantiateViewController(withIdentifier: "SubmitCodeController") as! SubmitCodeController
                    submitCodeCon.verficationUUID = verficationUUID ?? "no code"
                    submitCodeCon.navCon = self.navCon
                    submitCodeCon.isScreenTypeReusableResCon = self.isScreenTypeReusableResCon
                    self.dismiss(animated: true){
                        self.navCon.present(submitCodeCon, animated: true){
                            let toast = Toast.default(text: "Please check your verification code sent to your email", direction: .top)
                            toast.show()
                        }
                    }
                }
            }
            else{
                isAnimationFalse = true
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: "\(responce.forgotModel.first?.responseMessage ?? "Object not intialized")", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func loadingIndicator(){
        isAnimationFalse = false
        var loadingSupport = LoadingSupport()
        loadingSupport = self.storyboard?.instantiateViewController(withIdentifier: "LoadingSupport") as! LoadingSupport
        addChild(loadingSupport)
        self.view.addSubview(loadingSupport.view)
    }
    
}

extension ForgotPasswordController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
