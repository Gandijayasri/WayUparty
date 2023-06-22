//
//  TermsandConditionsVC.swift
//  wayUparty
//
//  Created by Arun  on 04/05/23.
//  Copyright © 2023 Jasty Saran . All rights reserved.
//

import UIKit

class TermsandConditionsVC: UIViewController {
    @IBOutlet weak var textVw: UITextView!
    var termsandConditions = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textVw.text = termsandConditions
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
}
