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
        
        let mainVC = MainVC()
        mainVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), selectedImage: nil)

        setViewControllers([UINavigationController(rootViewController: mainVC)], animated: true)

        setTabbarAppearance()
    }
    
    //MARK: - Functions
    
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
