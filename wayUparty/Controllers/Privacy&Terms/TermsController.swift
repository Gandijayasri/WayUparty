//
//  TermsController.swift
//  wayUparty
//
//  Created by Arun on 02/04/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import UIKit
import WebKit

class TermsController: UIViewController {

    @IBOutlet var termsView: WKWebView!
    @IBOutlet var okBttn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        okBttn.layer.cornerRadius = 15
        loadtermsandconditions()
        if #available(iOS 14.0, *) {
            termsView.pageZoom = 1.8
        } else {
            // Fallback on earlier versions
        }
        termsView.scrollView.showsHorizontalScrollIndicator = false
        termsView.scrollView.showsVerticalScrollIndicator = false
    }
    func loadtermsandconditions(){
        let constants = Constants()
        
        let Url = constants.baseUrl + "/termsAndConditions"
        let url = URL (string: Url)
        let requestObj = URLRequest(url: url!)
        termsView.load(requestObj)
    }
    
    @IBAction func AgreeAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
