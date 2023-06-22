//
//  GifLoaderController.swift
//  wayUparty
//
//  Created by Jasty Saran  on 25/11/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
import SwiftyGif

class GifLoaderController: UIViewController {
    @IBOutlet weak var gifImageView:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("start")
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
            do{
            let gif = try UIImage(gifName: "GIF_Screen.gif")
                self.gifImageView.setGifImage(gif, loopCount: 1)}catch{
                    
                }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.80, execute: {
           
           self.PushHome()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // DispatchQueue.main.asyncAfter(deadline: .now() + 2.50, execute: {
        
      //})
    }
    
    @objc func PushHome(){
        var homeScreen = HomeController()
        homeScreen = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        self.navigationController?.pushViewController(homeScreen, animated: true)
    }
    
}
