//
//  PrivacyController.swift
//  wayUparty
//
//  Created by Arun on 02/04/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import UIKit
import WebKit

class PrivacyController: UIViewController {
    @IBOutlet var privacyWeb: WKWebView!
    
    @IBOutlet var okBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        okBtn.layer.cornerRadius = 15
        loadprivacy()
        if #available(iOS 14.0, *) {
            privacyWeb.pageZoom = 1.8
        } else {
            // Fallback on earlier versions
        }
        privacyWeb.scrollView.showsHorizontalScrollIndicator = false
        privacyWeb.scrollView.showsVerticalScrollIndicator = false
    }
    func loadprivacy()  {
        let constants = Constants()
        
        let Url = constants.baseUrl + "/privacyPolicy"
        
        let url = URL (string: Url)
        let requestObj = URLRequest(url: url!)
        privacyWeb.load(requestObj)
    }
    
    @IBAction func dismissAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
  


}
extension WKWebView {

    
    func loadHTMLStringWithMagic(content:String,baseURL:URL?){
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        loadHTMLString(headerString + content, baseURL: baseURL)
    }
}
