//
//  SceneDelegate.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/8/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       print("In scene delagete begin")
       if let windowScene = scene as? UIWindowScene {

        let window = UIWindow(windowScene: windowScene)
        let containerViewController = ContainerViewController()
        let loginViewController = UIStoryboard.loginViewController()
        let loginNavigationController = UINavigationController(rootViewController: loginViewController!)
        loginNavigationController.isNavigationBarHidden = true
        if Utilities.readUserInfoFromFile() {
            window.rootViewController = containerViewController
            let pushManager = PushNotificationManager(userID: Utilities.currentUserName())
            pushManager.registerForPushNotifications()
        }
        else
        {
            window.rootViewController = loginNavigationController
        }
            self.window = window
            window.makeKeyAndVisible()
        }
        print("Scene delegate end")
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground: \(window?.rootViewController)")
    }
}

private extension UIStoryboard {
static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    static func loginViewController() -> LoginViewController? {
      return mainStoryboard().instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
    }
}