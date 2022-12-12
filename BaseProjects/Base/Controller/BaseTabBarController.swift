//
//  BaseTabBarController.swift
//  根TabBarController
//
//  Created by 张轩赫 on 2022/12/8.
//

import UIKit

class BaseTabBarController: UITabBarController {

    var lastItem: UITabBarItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = UIColor("#1CB496")
//        tabBar.backgroundColor = .cyan
        
        selectedIndex = 0
        lastItem = tabBar.selectedItem
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == lastItem && item.title == "首页" {
            guard let nav = viewControllers?.first as? UINavigationController else { return }
//            guard let home = nav.topViewController as? HomeViewController else  { return }
//            if home.homeCollectionView.contentOffset.y > CGFloat(0) {
//                home.homeCollectionView.setContentOffset(CGPoint(x: 0, y: -view.safeAreaInsets.top), animated: true)
//            }
        }
        lastItem = item
    }

}
