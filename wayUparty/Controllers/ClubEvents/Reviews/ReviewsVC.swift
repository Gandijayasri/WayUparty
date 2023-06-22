//
//  ReviewsVC.swift
//  wayUparty
//
//  Created by Arun  on 04/05/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit

class ReviewsVC: UIViewController {

    @IBOutlet weak var ratingsImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ratingsImg.setImageColor(color: UIColor.white)
        let userUUID = UserDefaults.standard.object(forKey: "userUUID") as? String ?? ""
        if userUUID == ""{
            ratingsImg.isHidden = true
        }else{
            ratingsImg.isHidden = false
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedMe))
        ratingsImg.addGestureRecognizer(tap)
        ratingsImg.isUserInteractionEnabled = true
    }
@objc func tappedMe() {
    let story = UIStoryboard(name: "Main", bundle: nil)
    let ratingsVC = story.instantiateViewController(withIdentifier: "RatingsPopUp") as! RatingsPopUp
    ratingsVC.modalPresentationStyle = .overCurrentContext
    self.present(ratingsVC, animated: false,completion: nil)
    
    
    }

    

    @IBAction func backAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}
