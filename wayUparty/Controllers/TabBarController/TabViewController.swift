//
//  TabViewController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 24/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
var tabBarScreen : String = "home"
class TabViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override var traitCollection: UITraitCollection{
        let realtraits = super.traitCollection
        let faketraits = UITraitCollection(horizontalSizeClass: .regular)
        return UITraitCollection(traitsFrom: [realtraits, faketraits])
        
        
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (self.tabBar.items!)[0]{
               tabBarScreen = "home"
           }
        else if item == (self.tabBar.items!)[1]{
              tabBarScreen = "cart"
           }
        else if item == (self.tabBar.items!)[2]{
            tabBarScreen = "events"
            
        }
        else if item == (self.tabBar.items!)[3]{
           tabBarScreen = "orders"
        }
        else if item == (self.tabBar.items!)[4]{
            tabBarScreen = "profile"
        }else if item == (self.tabBar.items!)[5]{
            tabBarScreen = "Refer"
        }
    }
    
    
//     func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//      
//        if tabBarController.selectedIndex == 0 {
//            print("its working")
//            self.tabBarController?.selectedIndex = 0
//            return false
//        }
//       else {
//               return true
//           }
//        
//    }
}
