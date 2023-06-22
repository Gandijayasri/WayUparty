//
//  CommentsController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 11/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit

class CommentsController: UIViewController {
    var heightsArray = Array<CGFloat>()
    var restuarentUUID = String()
    var userCommentModel:UserCommentModel!
    @IBOutlet weak var tableView: UITableView!
    lazy var tutorialVC: KJOverlayTutorialViewController = {
      return KJOverlayTutorialViewController()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reviews"
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        let barButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "write"), style: .plain, target: self, action: #selector(navigateToCommentScreen))
        self.navigationItem.rightBarButtonItem = barButtonItem
        // Do any additional setup after loading the view.
    }
    
    
    @objc func navigateToCommentScreen(){
        var writeReviewCon = WriteReviewController()
        writeReviewCon = self.storyboard?.instantiateViewController(identifier: "WriteReviewController") as! WriteReviewController
        writeReviewCon.restuarentUUID  = restuarentUUID
        self.navigationController?.pushViewController(writeReviewCon, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
          //self.showTutorial()
        }
        let constants = Constants()
        UserCommentModelParser.UserCommentModelParserAPI(xUsername: constants.xUsername, xPassword: constants.xPassword,vendorUUID: self.restuarentUUID){(responce) in
            self.userCommentModel = responce.userCommentModel.first
            isAnimationFalse =  true
            DispatchQueue.main.async {
                for i in 0..<(responce.userCommentModel.first?.ratingDescription.count)!{
                    let height =  self.heightForView(text:self.userCommentModel.ratingDescription[i], font: UIFont.systemFont(ofSize: 13), width: UIScreen.main.bounds.size.width - 15)
                    self.heightsArray.append(height)
                }
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }
    
    func showTutorial() {
      // tut1
     //20 for SE
        var focusRect1 = CGRect()
        if UIScreen.main.bounds.size.height == 568.0{focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-50, y: 20, width:40, height: 44)}
        if UIScreen.main.bounds.size.height == 667.0{
            focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-50, y: 20, width:40, height: 44)
        }
            if UIScreen.main.bounds.size.height == 812.0 {
        focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-50, y: 40, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 896{
            focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-55, y: 40, width:40, height: 44)
        }
        if UIScreen.main.bounds.size.height == 736.0{
            focusRect1 = CGRect.init(x: UIScreen.main.bounds.size.width-55, y: 20, width:40, height: 44)
        }

      let icon1Frame = CGRect(x: self.view.bounds.width/2-72/2, y: (focusRect1.maxY ) + 12, width: 72, height: 72)
      let message1 = "Write your review here"
      let message1Center = CGPoint(x: self.view.bounds.width/2, y: icon1Frame.maxY + 24)
      var tut1 = KJTutorial.textTutorial(focusRectangle: focusRect1 , text: message1, textPosition: message1Center)
      tut1.isArrowHidden = false
      
      // tuts
      let tutorials = [tut1]
      self.tutorialVC.tutorials = tutorials
      self.tutorialVC.showInViewController(self)
    }
    
  func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
      let label:UILabel = UILabel(frame: CGRect(x: 11, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
      label.numberOfLines = 0
      label.lineBreakMode = NSLineBreakMode.byWordWrapping
      label.font = font
      label.text = text
      label.sizeToFit()
      return label.frame.height
  }
}

class ViewCommentCell:UITableViewCell{
    @IBOutlet weak var ratingLbl:UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var userName:UILabel!
    @IBOutlet weak var timeDateLbl:UILabel!
}

class dynamicHHeightCell:UITableViewCell{
    @IBOutlet weak var dynamicHeightLbl: UILabel!
   
}


extension CommentsController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dynamicHHeightCell") as! dynamicHHeightCell
        cell.dynamicHeightLbl.frame = CGRect.init(x:cell.dynamicHeightLbl.frame.origin.x, y: cell.dynamicHeightLbl.frame.origin.y, width: UIScreen.main.bounds.size.width - 15, height: self.heightsArray[indexPath.row] + 70)
        cell.dynamicHeightLbl.text = self.userCommentModel.ratingDescription[indexPath.section]
        print(heightsArray)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.userCommentModel.rating.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightsArray[indexPath.row] + 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewCommentCell") as! ViewCommentCell
        cell.ratingView.layer.cornerRadius = 10
        cell.ratingLbl.text = "\(self.userCommentModel.rating[section])"
        cell.userName.text = self.userCommentModel.userName[section]
        let timeDateLbl = self.userCommentModel.createdDate[section] + self.userCommentModel.createdTime[section]
        cell.timeDateLbl.text = timeDateLbl
        cell.backgroundColor = .clear
        return cell
    }
    
    func loadingIndicator(){
        isAnimationFalse = false
        var loadingSupport = LoadingSupport()
        loadingSupport = self.storyboard?.instantiateViewController(withIdentifier: "LoadingSupport") as! LoadingSupport
        addChild(loadingSupport)
        self.view.addSubview(loadingSupport.view)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 79
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

