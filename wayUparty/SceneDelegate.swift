//
//  SceneDelegate.swift
//  wayUparty
//
//  Created by Jasty Saran  on 01/09/20.
//  Copyright © 2020 Jasty Saran . All rights reserved.
//

import UIKit
var Window:UIWindow?
var BIGsCENE : UIWindowScene?
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainNavigationController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let windowscene = scene as? UIWindowScene{
            let window = UIWindow(windowScene: windowscene)
            self.mainNavigationController.navigationBar.isHidden = false
            self.mainNavigationController.navigationBar.tintColor = UIColor.black
            self.window = window
            }
        loadBaseController()
    }
    func loadBaseController() {
      // let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
       guard let window = self.window else { return }
       window.makeKeyAndVisible()
       if UserDefaults.standard.value(forKey: "SEEN-TUTORIAL") == nil {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let initialVC = story.instantiateViewController(withIdentifier: "Agerestriction") as! Agerestriction
              self.mainNavigationController = UINavigationController(rootViewController: initialVC)
        self.mainNavigationController.navigationBar.isHidden = false
        self.window?.rootViewController = self.mainNavigationController
       } else {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let initialVC = story.instantiateViewController(withIdentifier: "SetYourLocation") as! SetYourLocation
              self.mainNavigationController = UINavigationController(rootViewController: initialVC)
        self.mainNavigationController.navigationBar.isHidden=true
              self.window?.rootViewController = self.mainNavigationController
       }
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

