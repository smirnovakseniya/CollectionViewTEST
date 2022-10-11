//
//  TabBarVC.swift
//  TESTCollectionVIew
//
//  Created by Kseniya Smirnova on 6.10.22.
//

import UIKit

class TabBarVC: UITabBarController {

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstController = MainVC()
        firstController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), selectedImage: nil)

//        let secondController = SecondVC()
//        secondController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "globe.europe.africa.fill"), selectedImage: nil)

        setViewControllers([
            UINavigationController(rootViewController: firstController)
//            UINavigationController(rootViewController: secondController)
        ], animated: true)

        setTabbarAppearance()
    }
    
    //MARK: - TabBar
    
    func setTabbarAppearance() {
        tabBar.barTintColor = .white
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.itemPositioning = .fill
        tabBar.backgroundColor = .white
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = self.tabBar.items?.firstIndex(of: item),
              let imageView = tabBar.subviews[index + 1].subviews.first as? UIImageView else { return }
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut) {
            imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

            UIView.animate(withDuration: 0.5,
                           delay: 0.2,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseInOut) {
                imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
                       }
    }
}
