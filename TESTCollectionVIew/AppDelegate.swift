//
//  AppDelegate.swift
//  TESTCollectionVIew
//
//  Created by Kseniya Smirnova on 5.10.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.rootViewController = UINavigationController(rootViewController: TabBarVC())
        window.rootViewController = TabBarVC()
        window.makeKeyAndVisible()
        self.window = window
        
        setupNavBarAppearance()
        
        IAPManager.shared.fetchProduct()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    func setupNavBarAppearance() {
//                let navBarAppearance = UINavigationBarAppearance()
//                navBarAppearance.configureWithDefaultBackground()
//                navBarAppearance.backgroundColor = .white
//
//                UINavigationBar.appearance().standardAppearance = navBarAppearance
//
    

        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().tintColor = .white
       
        
        
    }
}


