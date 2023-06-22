//
//  ProfileDetails.swift
//  wayUparty
//
//  Created by Arun on 04/03/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import UIKit
import Kingfisher

class ProfileDetails: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var profileImgVW: UIImageView!
    
    @IBOutlet weak var choosePic: UIButton!
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var mobileTF: UITextField!{
    didSet {
        mobileTF?.addDoneCancelToolbar() }
}
    
    @IBOutlet weak var dobTextFeild: UITextField!
    
    @IBOutlet weak var genderBtn: UIButton!
    
    @IBOutlet weak var preferredBtn: UIButton!
    
    @IBOutlet weak var preferredDrinksBtn: UIButton!
    
    var selectedImage: UIImage?
    var imagePicker = UIImagePickerController()
    var profileImageView = UIImageView()
    var multiPartImage:UIImage?
    var imageFileInfo = String()
    let imageCache = NSCache<AnyObject, AnyObject>()
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    var maleBtn = UIButton()
    var femaleBtn = UIButton()
    var drinkPickerValues = Array<String>()
    var musicPickerValues = Array<String>()
    var genderpickerValue = String()
    var popupView : UIView!
    var prefferedDrinksLbl = UILabel()
    var prefferedMusicLbl = UILabel()
    var dobTxtFeild = UITextField()
    var firstName = String()
    var email = String()
    var mobile = String()
    var gender = String()
    var dob = String()
    var setKeyboardFrame :Bool = false
    var voterIdTxtFeild = UITextField()
    var mobileTxtFeild = UITextField()
    var nameTxtFeild = UITextField()
    var timer:Timer?
    var maskview : UIView!
    var isScreenTypeReusableResCon: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        SetUIElements()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(assignObjectToTextFeild), userInfo: nil, repeats: true)
        
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        mobileTF.resignFirstResponder()
            return true
        }
    @objc func assignObjectToTextFeild(){
        dobTxtFeild.text = dobOfUser
        dobTxtFeild.resignFirstResponder()
    }
    @IBAction func SaveUserProfile(){
        self.loadingIndicator()
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String ?? ""
        var fileUrl = String()
        if imageFileInfo == ""{
            let userImage = UserDefaults.standard.object(forKey: "userImage") as? String ?? ""
            fileUrl = userImage}
        else{fileUrl = imageFileInfo}
        let constants = Constants()
        self.firstName = self.nameTF.text ?? "Oops something went wrong"
        print("name:\(self.firstName)")
        print("gender:\(gender)")
        print("mobile:\(mobile)")
        print("email:\(email)")
        print("drimks:\(drinkPickerValues)")
        print("music:\(musicPickerValues)")
        print("dob:\(dobOfUser)")
        
        let userProfile = ["userUUID":userUUID,"firstName":self.firstName,"lastName":"","email":self.email, "mobile":self.mobile, "gender":self.gender, "preferredDrinks":drinkPickerValues.joined(separator: ","), "preferredMusic":musicPickerValues.joined(separator: ","), "dob":dobOfUser,"profileImageUrl":fileUrl] as [String : Any]
        SaveUserProfileParser.SaveUserProfileAPI(xUsername: constants.xUsername, xpassword: constants.xPassword, userProfile: userProfile){(responce) in
            isAnimationFalse = true
            let message = responce.loginModel.first?.response ?? String()
            if message == "SUCCESS"{
               print(responce.loginModel.first?.loginUserName ?? String())
               UserDefaults.standard.set(responce.loginModel.first?.userUUID ?? String(), forKey: "userUUID")
                UserDefaults.standard.setValue(responce.loginModel.first?.userImage ?? String(), forKey: "userImage")
                UserDefaults.standard.setValue(responce.loginModel.first?.loginUserName ?? String(), forKey: "loginUserName")
                UserDefaults.standard.set(responce.loginModel.first?.userEmail ?? String(), forKey: "userEmail")
                UserDefaults.standard.set(responce.loginModel.first?.userMobile ?? String(), forKey: "userMobile")
                UserDefaults.standard.setValue(responce.loginModel.first?.dob ?? String(), forKey: "dob")
                UserDefaults.standard.set(responce.loginModel.first?.preferredDrinksList ?? Array<String>(), forKey: "preferredDrinksList")
                UserDefaults.standard.set(responce.loginModel.first?.preferredMusicList ?? Array<String>(), forKey: "preferredMusicList")
                UserDefaults.standard.set(responce.loginModel.first?.gender ?? String(), forKey: "gender")
                let gender = UserDefaults.standard.object(forKey: "gender")
                print("Gender:\(String(describing: gender) )")
                
                UserDefaults.standard.set(responce.loginModel.first?.preferredDrinks ?? String(), forKey: "preferredDrinks")
                UserDefaults.standard.set(responce.loginModel.first?.preferredMusic ?? String(), forKey: "preferredMusic")
                UserDefaults.standard.setValue(responce.loginModel.first?.userImage ?? String(), forKey: "userImage")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: responce.loginModel.first?.responseMessage ?? "Somethhing went wrong", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
   
    @objc func donebuttonClicked(){
        if maskview.isHidden {
            maskview.isHidden = false
            
            } else {
                maskview.isHidden = true
                
                
                
            }
    }
    
    
    @objc func maleBtnAction(_sender:UIButton){
        if _sender.isSelected == true{
            
            _sender.isSelected = false
            femaleBtn.setImage(UIImage(named: "Radio.png"), for:.normal)
        }else{
            _sender.isSelected = true
            femaleBtn.isSelected = false
            femaleBtn.setImage(UIImage(named: "Radio.png"), for:.normal)
            maleBtn.setImage(UIImage(named: "check"), for:.normal)
        }
        gender = "Male"
        genderBtn.setTitle(gender, for: .normal)
        
        
       
    }
    
    @objc func femaleBtnAction(_sender:UIButton){
        if _sender.isSelected == true{
           
            _sender.isSelected = false
            maleBtn.setImage(UIImage(named: "Radio.png"), for:.normal)
        }else{
            _sender.isSelected = true
            maleBtn.isSelected = false
            maleBtn.setImage(UIImage(named: "Radio.png"), for:.normal)
            femaleBtn.setImage(UIImage(named: "check"), for:.normal)
        }
        gender = "Female"
        genderBtn.setTitle(gender, for: .normal)
       
        
    }
    @objc func GenderPopup(){
         maskview = UIView(frame:CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.view.frame.size.height))
        maskview.backgroundColor = UIColor.init(red: 127/255, green: 127/255, blue: 127/255, alpha: 0.8)
        self.view.addSubview(maskview)
       
        
        
        popupView = UIView(frame: CGRect(x: 50, y: self.view.center.y - 210, width:self.view.frame.size.width - 100, height:150 ))
        popupView.backgroundColor = UIColor.white
        popupView.layer.cornerRadius = 10
        let titleLbl = UILabel(frame:CGRect(x:self.popupView.center.x - 100,y:10,width:150,height:20))
        titleLbl.text = "Select Gender"
        self.popupView.addSubview(titleLbl)
        let lineview = UIView(frame: CGRect(x: 0, y: 115, width: self.popupView.frame.size.width, height: 2))
        lineview.backgroundColor = UIColor.init(red: 243/255, green: 194/255, blue: 69/255, alpha: 0.8)
        self.popupView.addSubview(lineview)
        let cancel = UIButton(frame:CGRect(x:self.popupView.center.x ,y:125,width:80,height:20))
       
        cancel.setTitle("Cancel", for: .normal)
        cancel.addTarget(self, action: #selector(donebuttonClicked), for: .touchUpInside)
        self.popupView.addSubview(cancel)
        
        let DoneBtn = UIButton(frame:CGRect(x:10,y:125,width:80,height:20))
        
       
        DoneBtn.setTitle("Done", for: .normal)
        DoneBtn.setTitleColor(.black, for: .normal)
        cancel.setTitleColor(.black, for: .normal)
        DoneBtn.addTarget(self, action: #selector(donebuttonClicked), for: .touchUpInside)
        self.popupView.addSubview(DoneBtn)
        maleBtn = UIButton(frame:CGRect(x:self.view.center.x, y:50, width:20, height:20))
        maleBtn.setImage(UIImage(named: "Radio.png"), for:.normal)
        femaleBtn = UIButton(frame:CGRect(x:self.view.center.x, y:90, width:20, height:20))
        femaleBtn.setImage(UIImage(named: "Radio.png"), for:.normal)
        maleBtn.addTarget(self, action: #selector(maleBtnAction), for: .touchUpInside)
        femaleBtn.addTarget(self, action: #selector(femaleBtnAction), for: .touchUpInside)
        maleBtn.tag = 0
        femaleBtn.tag = 1
        let gender = UserDefaults.standard.object(forKey:"gender") as? String ?? ""
        if gender != "" {
            if gender == "Male"{maleBtn.isSelected = true;self.gender="Male"
                maleBtn.setImage(UIImage(named: "check"), for:.normal)
            }
            if gender == "Female"{femaleBtn.isSelected = true;self.gender="Female"
                femaleBtn.setImage(UIImage(named: "check"), for:.normal)
            }
        }
        self.popupView.addSubview(maleBtn)
        self.popupView.addSubview(femaleBtn)
        let malelable = UILabel(frame:CGRect(x:10,y:50,width:60,height:20))
        malelable.text = "Male"
       let femaleLbl = UILabel(frame:CGRect(x:10 ,y:90,width:60,height:20))
        femaleLbl.text = "Female"
       self.popupView.addSubview(malelable)
       self.popupView.addSubview(femaleLbl)
        maskview.addSubview(popupView)
      
    }
   
   
    func SetUIElements() {
        genderBtn.layer.cornerRadius = 8
        preferredBtn.layer.cornerRadius = 8
        preferredDrinksBtn.layer.cornerRadius = 8
        dobTextFeild.layer.cornerRadius = 8
        profileImgVW.layer.cornerRadius = 60
        profileImgVW.layer.borderWidth = 1
        profileImgVW.layer.borderColor = UIColor.white.cgColor
        let constants = Constants()
        let profileimgUrl = UserDefaults.standard.object(forKey: "userImage") as? String ?? "";
        if let url = URL(string: constants.baseUrl+profileimgUrl){
        
        let resource = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                   
                    self.profileImgVW.image = value.image.resizeWith(percentage: 0.25)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
          
       
        
        nameTF.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let name = UserDefaults.standard.object(forKey: "loginUserName") as? String ?? ""
        if name != ""{
            nameTF.text = name
        }
        self.firstName = nameTF.text ?? String()
        let email = UserDefaults.standard.object(forKey: "userEmail") as? String ?? ""
         if email != ""{
            self.email = email
            emailTF.text = self.email
         }
        emailTF.isUserInteractionEnabled = false
        self.email = emailTF.text ?? String()
        emailTF.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        dobTextFeild.delegate = self
        self.dobTxtFeild = self.dobTextFeild
        dobTxtFeild.tag = 1
        self.dobTxtFeild.text = dobOfUser
        dobTextFeild.setTextFeildBorderLine(txtFeild: dobTextFeild)
        dobTxtFeild.inputView = UIView()
        mobileTF.setTextFeildBorderLine(txtFeild: mobileTF)
        let mobile = UserDefaults.standard.object(forKey: "userMobile") as? String ?? ""
        if mobile != ""{
            self.mobile = mobile
            mobileTF.text = self.mobile
        }
        self.mobile = mobileTF.text ?? String()
        mobileTF.attributedPlaceholder = NSAttributedString(string: "Mobile",
                                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        if self.drinkPickerValues.count == 0{}
        else{preferredDrinksBtn.setTitle("\(self.drinkPickerValues.count) drinks selected", for: .normal)  }
        if self.musicPickerValues.count == 0{}
        else{preferredBtn.setTitle("\(self.musicPickerValues.count) generes selected ", for: .normal)}
        preferredDrinksBtn.addTarget(self, action: #selector(presentTextPicker), for: .touchUpInside)
        let gender = UserDefaults.standard.object(forKey:"gender") as? String ?? ""
        if gender != "" {
            self.gender = gender
            genderBtn.setTitle(self.gender, for: .normal)
        }
        self.profileImageView = profileImgVW
        preferredBtn.addTarget(self, action: #selector(presentMusicPicker), for: .touchUpInside)
        genderBtn.addTarget(self, action: #selector(GenderPopup), for: .touchUpInside)
        choosePic.addTarget(self, action: #selector(editProfileTocuhEvent), for: .touchUpInside)
        nameTF.delegate = self
        emailTF.delegate = self
        mobileTF.delegate = self
    }

    @objc func editProfileTocuhEvent(){
        self.openPhtoLibrary()
    }
}
extension ProfileDetails:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.dobTxtFeild{
            var child = DatePickerViewController()
            child = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
            addChild(child)
            view.addSubview(child.view)
            child.didMove(toParent: self)
        }
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.nameTxtFeild{
            self.firstName = textField.text ?? "Opps Some thing went wrong"
        }
    }
   
    
   @objc func presentTextPicker(){
        let blueAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Drinks",
            titleFont           : boldFont,
            titleTextColor      : .black,
            titleBackground     : .clear,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search Fruits",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "Done",
            doneButtonColor     : UIColor.systemBlue,
            doneButtonFont      : boldFont,
            checkMarkPosition   : .Right,
            itemCheckedImage    : UIImage(named:"blue_ic_checked"),
            itemUncheckedImage  : UIImage(),
            itemColor           : .black,
            itemFont            : regularFont
        )

        let fruits = UserDefaults.standard.array(forKey: "preferredDrinksList") as? [String]
        let picker = YBTextPicker.init(with: fruits!, appearance: blueAppearance,onCompletion: { (selectedIndexes, selectedValues) in
        if selectedValues.count > 0{
         var values = [String]()
         for index in selectedIndexes{
            values.append(fruits![index])
            self.drinkPickerValues = values
        }
            self.preferredDrinksBtn.setTitle("\(self.drinkPickerValues.count) drinks selected", for: .normal)
        }else{
          // reset the selection if nothing happens
          }
        },onCancel: {
          print("Cancelled")
        }
        )
        if drinkPickerValues.count == 0{}
        else{picker.preSelectedValues = self.drinkPickerValues
            
        }
        picker.allowMultipleSelection = true
        picker.show(withAnimation: .Fade)
       
    }
    
   @objc func presentMusicPicker(){
        let blueAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Genere",
            titleFont           : boldFont,
            titleTextColor      : .black,
            titleBackground     : .clear,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search Fruits",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "Done",
            doneButtonColor     : UIColor.systemBlue,
            doneButtonFont      : boldFont,
            checkMarkPosition   : .Right,
            itemCheckedImage    : UIImage(named:"blue_ic_checked"),
            itemUncheckedImage  : UIImage(),
            itemColor           : .black,
            itemFont            : regularFont
        )

        let fruits = UserDefaults.standard.array(forKey: "preferredMusicList") as? [String]
        let picker = YBTextPicker.init(with: fruits!, appearance: blueAppearance,onCompletion: { (selectedIndexes, selectedValues) in
        if selectedValues.count > 0{
         var values = [String]()
         for index in selectedIndexes{
            values.append(fruits![index])
            self.musicPickerValues = values
        }
            self.preferredBtn.setTitle("\(self.musicPickerValues.count) generes selected ", for: .normal)
        }else{
          // reset the selection if nothing happens
          }
        },onCancel: {
          print("Cancelled")
        }
        )
        if musicPickerValues.count == 0{}
        else{picker.preSelectedValues = self.musicPickerValues}
        picker.allowMultipleSelection = true
        picker.show(withAnimation: .Fade)
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
    
}
extension ProfileDetails{
    func sendFile(typeOfInput:String,
        urlPath:String,
        fileName:String,
        data:NSData,
        completionHandler: @escaping (URLResponse?, NSData?, NSError?) -> Void){
        let url: NSURL = NSURL(string: urlPath)!
        let request1: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        request1.httpMethod = "POST"
        let boundary = self.generateBoundary()
        let fullData = photoDataToFormData(data: data,boundary:boundary,fileName:fileName, typeOfInput: typeOfInput)
        request1.setValue("multipart/form-data; boundary=" + boundary,
                forHTTPHeaderField: "Content-Type")
            // REQUIRED!
        let constansts = Constants()
        request1.setValue(String(fullData.length), forHTTPHeaderField: "Content-Length")
        request1.setValue(constansts.xUsername, forHTTPHeaderField: "X-Username")
        request1.setValue(constansts.xPassword, forHTTPHeaderField: "X-Password")
        request1.httpBody = fullData as Data
        request1.httpShouldHandleCookies = false
        let _:OperationQueue = OperationQueue()
        URLSession.shared.dataTask(with: request1 as URLRequest){data,respoce,error in
            do{
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray
                let fileInfo = result?.object(at: 0) as? [String:Any] ?? [:]
                if typeOfInput == "image"{
                self.imageFileInfo = fileInfo["fileURL"] as? String ?? "no object named fileInfo"
                UserDefaults.standard.setValue(self.imageFileInfo, forKey: "userImage")
                }
            isAnimationFalse = true
          }catch{}
       }.resume()
    }

    
    func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    // this is a very verbose version of that function
    // you can shorten it, but i left it as-is for clarity
    // and as an example
    func photoDataToFormData(data:NSData,boundary:String,fileName:String,typeOfInput:String) -> NSData {
        let fullData = NSMutableData()
        var lineThree = String()
        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(
                            using: String.Encoding.utf8,
        allowLossyConversion: false)!)
        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
        NSLog(lineTwo)
        fullData.append(lineTwo.data(
                            using: String.Encoding.utf8,
        allowLossyConversion: false)!)

        // 3
        if typeOfInput == "image"{ lineThree = "Content-Type: image/jpg\r\n\r\n"}
        if typeOfInput == "video"{
            lineThree = "Content-Type: video/mp4\r\n\r\n"}
        fullData.append(lineThree.data(
                            using: String.Encoding.utf8,
        allowLossyConversion: false)!)

        // 4
        fullData.append(data as Data)

        // 5
        let lineFive = "\r\n"
        fullData.append(lineFive.data(
                            using: String.Encoding.utf8,
        allowLossyConversion: false)!)

        // 6 - The end. Notice -- at the start and at the end
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(
                            using: String.Encoding.utf8,
        allowLossyConversion: false)!)

        return fullData
    }
}

extension ProfileDetails:UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        if let mediaType = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerMediaType")] as? String {
            if mediaType  == "public.image" {
            print("Image Selected")
            if let img = info[.originalImage] {
            self.multiPartImage = img as? UIImage
            self.profileImageView.image = self.multiPartImage
            picker.dismiss(animated: true, completion: {
                    UIView.animate(withDuration: 2) {
                }
            })
            self.selectedImage = img as? UIImage
            let data = self.multiPartImage?.jpegData(compressionQuality: 0.3)
                self.loadingIndicator()
                let constants = Constants()
                self.sendFile(typeOfInput: "image", urlPath: "\(constants.baseUrl)/rest/uploadProfileImage", fileName: "profile.jpg", data: data! as NSData){data,responce,error in
                    
                }
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
    
    @objc func openPhtoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                    imagePicker.delegate = self
                    imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.mediaTypes = ["public.image"]
                    imagePicker.allowsEditing = false
                    present(imagePicker, animated: true, completion: nil)
                }
    }
    
}
