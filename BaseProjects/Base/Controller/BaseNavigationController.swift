//
//  BaseNavigationController.swift
//  根NavigationController
//
//  Created by 张轩赫 on 2022/12/8.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white
        //正常导航栏
        navigationBar.standardAppearance = navBarAppearance
        //滚动之后的导航栏
        navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationBar.tintColor = .black
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count >= 1 {
            viewController.hidesBottomBarWhenPushed = true

            let leftImage = UIBarButtonItem(image: UIImage(named: "返回"), style: .plain, target: self, action: #selector(popViewController(animated:)))
//            let leftTitle = UIBarButtonItem(title: "公司", style: .plain, target: self, action: #selector(popViewController(animated:)))
//            viewController.navigationItem.setLeftBarButtonItems([leftImage], animated: true)
        }
        super.pushViewController(viewController, animated: animated)
    }
    
}
