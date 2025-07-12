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
        

        // In your case
        UITabBar.appearance().unselectedItemTintColor = .black
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.shadowColor = .white
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        // 设置未选中文字颜色
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor("#333333")]
            // 设置选中文字颜色
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor("#025BFF")]
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        
        selectedIndex = 0
        lastItem = tabBar.selectedItem
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
