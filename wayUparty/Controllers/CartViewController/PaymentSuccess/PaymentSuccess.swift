//
//  PaymentSuccess.swift
//  wayUparty
//
//  Created by Arun on 01/03/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import UIKit

class PaymentSuccess: UIViewController {

    @IBOutlet var completeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.hideSwiftLoader()
        completeBtn.layer.cornerRadius = 20
        completeBtn.addTarget(self, action: #selector(BacktoCartVC), for: .touchUpInside)
    }
    @objc func BacktoCartVC(){
    guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as? TabViewController else {return}
    UIApplication.shared.windows.first?.rootViewController = rootVC
    UIApplication.shared.windows.first?.makeKeyAndVisible()
   
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
