//
//  Agerestriction.swift
//  wayUparty
//
//  Created by Arun on 01/04/21.
//  Copyright © 2021 Jasty Saran . All rights reserved.
//

import UIKit

class Agerestriction: UIViewController {

    @IBOutlet var agreeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        agreeBtn.layer.cornerRadius = 15
        UserDefaults.standard.set(true, forKey: "SEEN-TUTORIAL")
    }
    
    @IBAction func termsVcAct(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let termsVc = story.instantiateViewController(withIdentifier: "TermsController") as! TermsController
        termsVc.modalPresentationStyle = .fullScreen
        self.present(termsVc, animated: true, completion: nil)
    }
    
    @IBAction func privacyVc(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let privacyVc = story.instantiateViewController(withIdentifier: "PrivacyController") as! PrivacyController
        privacyVc.modalPresentationStyle = .fullScreen
        self.present(privacyVc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func locateAct(_ sender: UIButton) {

               let story = UIStoryboard(name: "Main", bundle: nil)
                let locationVc = story.instantiateViewController(withIdentifier: "SetYourLocation") as! SetYourLocation
                locationVc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(locationVc, animated: true)
        
    }
    
    
    
}
