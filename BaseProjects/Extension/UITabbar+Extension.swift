//
//  UITabbar+Extension.swift
//  UITabbar+Extension
//
//  Created by 张轩赫 on 2021/8/30.
//

import UIKit

extension UITabBar {
    
    /// 显示角标
    func showBadgeOnItem(index: Int, count: Int) {
        removeBadgeOnItem(index: index)
        
        let badgeView = UIView()
        badgeView.tag = 888 + index
        badgeView.layer.cornerRadius = 9
        badgeView.clipsToBounds = true
        badgeView.backgroundColor = .red
        
        let tabBarItemCount = items?.count ?? 5
        let percentX = (Float(index) + 0.55) / Float(tabBarItemCount)
        let x = CGFloat(percentX) * frame.width
        let y: CGFloat = 3
        
        badgeView.frame = CGRect(x: x, y: y, width: 18, height: 18)
        
        let label = UILabel()
        label.text = count > 99 ? "99+" : "\(count)"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        label.textAlignment = .center
        label.frame = badgeView.bounds
        badgeView.addSubview(label)
        
        addSubview(badgeView)
        bringSubviewToFront(badgeView)
    }
    
    /// 隐藏角标
    func hideBadgeOnItem(index: Int) {
        removeBadgeOnItem(index: index)
    }
    
    /// 移除角标控件
    func removeBadgeOnItem(index: Int) {
        subviews.filter { $0.tag == 888 + index }.forEach { $0.removeFromSuperview() }
    }
}
