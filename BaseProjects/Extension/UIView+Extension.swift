//
//  UIView+Extension.swift
//  UIView+Extension
//
//  Created by 张轩赫 on 2022/5/9.
//

import UIKit
import SwiftMessages

extension UIView {
    
    /// 从与类名同名的 XIB 加载视图
    public class func initFromNib<T: UIView>() -> T {
        let className = String(describing: self)
        guard let view = Bundle.main.loadNibNamed(className, owner: nil, options: nil)?.first as? T else {
            fatalError("❌ 无法从 XIB 加载视图: \(className)")
        }
        return view
    }
    /// 通过 XIB 名加载视图（identifier 与类名一致）
    public class func initByName(xibName: String) -> UIView {
        guard let views = Bundle.main.loadNibNamed(xibName, owner: nil, options: nil),
              let view = views.first as? UIView
        else {
            fatalError("❌ 无法从 XIB 加载视图: \(xibName)")
        }
        return view
    }
    
    /// 使用 SwiftMessages 显示当前视图为弹窗
        ///
        /// - Parameters:
        ///   - presentationStyle: 弹窗显示的位置（默认居中 `.center`，也可选 `.top`、`.bottom`）
        ///   - alpha: 背景遮罩的透明度（0~1，默认 0.5）
        ///   - interactiveHide: 是否允许点击遮罩关闭弹窗（默认 false）
        func show(presentationStyle: SwiftMessages.PresentationStyle = .center,
                  alpha: Double = 0.5,
                  interactiveHide: Bool = false) {

            // 初始化默认配置
            var config = SwiftMessages.defaultConfig

            // 设置弹窗上下文为 window 级别，放在状态栏窗口层级上
            config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)

            // 设置展示时长为永久（需要手动关闭）
            config.duration = .forever

            // 是否允许用户手势关闭（如点击、滑动）
            config.interactiveHide = interactiveHide

            // 设置弹窗的展示位置样式（如顶部、底部、居中）
            config.presentationStyle = presentationStyle

            // 设置弹窗背景遮罩颜色及交互关闭
            config.dimMode = .color(
                color: .black.withAlphaComponent(alpha),    // 半透明黑色遮罩
                interactive: interactiveHide                // 是否允许点遮罩关闭
            )

            // 展示当前视图（self）作为 SwiftMessages 弹窗内容
            SwiftMessages.show(config: config, view: self)
        }

        /// 关闭当前正在展示的 SwiftMessages 弹窗
        func hide() {
            SwiftMessages.hide()
        }
    
    /// 给指定角切圆角
    /// - Parameters:
    ///   - corners: [.topLeft, .topRight] 这样的组合
    ///   - radius: 圆角半径
    func addCorner(corners: UIRectCorner, radius: CGFloat) {
        layoutIfNeeded()
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    /// 添加渐变背景色
    /// - Parameters:
    ///   - rellay: 可传入已有的 CAGradientLayer，若为 nil 自动创建
    ///   - fr: 渐变层尺寸（一般传 view.bounds）
    ///   - colors: 渐变颜色数组（CGColor）
    ///   - startPoint: 起始点，默认左下
    ///   - endPoint: 结束点，默认右下
    ///   - locations: 渐变位置分布，默认 [0, 1]
    func setGtradientLayer(rellay: CAGradientLayer? = nil,
                           fr: CGRect,
                           colors: [CGColor],
                           startPoint: CGPoint = CGPoint(x: 0, y: 1),
                           endPoint: CGPoint = CGPoint(x: 1, y: 1),
                           locations: [NSNumber] = [0, 1]) {
        let gradientLayer = rellay ?? CAGradientLayer()
        gradientLayer.frame = fr
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
