//
//  UIView+Extension.swift
//  UIView+Extension
//
//  Created by 张轩赫 on 2022/5/9.
//

import UIKit

extension UIView {
    /**
     *  切圆角
     *  - parameter conrners: 切的位置  radius: 角度多大
     */
    func addCorner(conrners: UIRectCorner , radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
