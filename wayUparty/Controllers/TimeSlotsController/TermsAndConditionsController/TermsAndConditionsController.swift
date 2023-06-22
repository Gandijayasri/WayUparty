//
//  TermsAndConditionsController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 29/12/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import WebKit
class TermsAndConditionsController: UIViewController {
    var vendorUUID:String = ""
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(NSURLRequest(url: NSURL(string: "https://www.alchohome.com/ws/vendorTermsAndCondtions?vendorUUID=\(vendorUUID)")! as URL) as URLRequest)
    }
}
