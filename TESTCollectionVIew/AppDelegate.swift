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
        window.rootViewController = TabBarVC()
        window.makeKeyAndVisible()
        window.overrideUserInterfaceStyle = .light
        self.window = window
        
        setupNavBarAppearance()
        
        IAPManager.shared.fetchProduct()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NetworkManager.shared.cache.removeAllObjects()
    }
    
    func setupNavBarAppearance() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black as Any,
                                                .font: Fonts.latoMedium.rawValue.withSize(20) as Any]
        navBarAppearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = navBarAppearance
    }
}


