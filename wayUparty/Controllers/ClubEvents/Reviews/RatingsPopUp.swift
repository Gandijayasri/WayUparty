//
//  RatingsPopUp.swift
//  wayUparty
//
//  Created by Arun  on 10/05/23.
//  Copyright © 2023 Arun. All rights reserved.
//

import UIKit
import AARatingBar

class RatingsPopUp: UIViewController {

    @IBOutlet var backVw: UIView!
    
    @IBOutlet weak var ratingVw: AARatingBar!
    
    @IBOutlet weak var ratingLbl: UILabel!
    
    @IBOutlet weak var feedbackView: UITextView!
    
    var placeholder = "Please provide your description here"
    override func viewDidLoad() {
        super.viewDidLoad()

//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
//        backVw.addGestureRecognizer(tap)
//        backVw.isUserInteractionEnabled = true
        setUiElements()
        hideKeyboardWhenTappedAround()
        
    }
    func setUiElements()  {
        ratingVw.starAlignment = .center
        ratingVw.ratingDidChange = { ratingValue in
            if ratingValue == 1.0{
                self.ratingLbl.text = "Very Bad"
            }else if ratingValue == 2.0 {
                self.ratingLbl.text = "Bad"
            }else if ratingValue == 3.0 {
                self.ratingLbl.text = "Average"
            }else if ratingValue == 4.0 {
                self.ratingLbl.text = "Good"
            }else if ratingValue == 5.0 {
                self.ratingLbl.text = "Loved It!"
            }
            
            
        }
        feedbackView.text = placeholder
        self.feedbackView.delegate = self
        if placeholder == "Please provide your description here" {
            feedbackView.textColor = .lightGray
        } else {
           feedbackView.textColor = .black
        }
        
    }
    @objc func dismissVC(){
        self.dismiss(animated: false,completion: nil)
    }

    @IBAction func dismissAct(_ sender: Any) {
        self.dismiss(animated: false,completion: nil)
    }
    

}

extension RatingsPopUp:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.textColor == .lightGray {
               textView.text = nil
               textView.textColor = .black
           }
       }
       
       func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = placeholder
               textView.textColor = UIColor.lightGray
               placeholder = ""
           } else {
               placeholder = textView.text
           }
       }
       
       func textViewDidChange(_ textView: UITextView) {
           placeholder = textView.text
       }
}
