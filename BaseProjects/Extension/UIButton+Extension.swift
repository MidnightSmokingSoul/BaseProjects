//
//  UIButton+Extension.swift
//  JinDuoDuo
//
//  Created by 张轩赫 on 2024/7/26.
//

import UIKit

enum XHButtonMode {
    case top, bottom, left, right
}

extension UIButton {
    
    /// 快速设置按钮内容的内边距（图片和文字统一的间距）
    /// - Parameters:
    ///   - topSpace: 上边距，默认5
    ///   - leftSpace: 左边距，默认5
    func xhJustTitle(topSpace: CGFloat = 5, leftSpace: CGFloat = 5) {
        if #available(iOS 15.0, *) {
            var config = self.configuration ?? UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: topSpace, leading: leftSpace, bottom: topSpace, trailing: leftSpace)
            self.configuration = config
        } else {
            let edgeInsets = UIEdgeInsets(top: topSpace, left: leftSpace, bottom: topSpace, right: leftSpace)
            self.contentHorizontalAlignment = .center
            self.contentVerticalAlignment = .center
            self.contentEdgeInsets = edgeInsets
        }
    }
    
    /// 调整按钮中图片和文字的位置关系
    /// - Parameters:
    ///   - style: 图片位置，默认为左侧
    ///   - space: 图片和文字间距，默认5
    func xhLocationAdjust(style: XHButtonMode = .left, space: CGFloat = 5) {
        
        if #available(iOS 15.0, *) {
            var config = self.configuration ?? UIButton.Configuration.plain()
            config.imagePlacement = {
                switch style {
                case .top: return .top
                case .bottom: return .bottom
                case .left: return .leading
                case .right: return .trailing
                }
            }()
            config.imagePadding = space
            self.configuration = config
            
            // 如果要调整contentEdgeInsets用contentInsets
            // 这里不额外设置contentInsets，默认即可
        } else {
            guard let imageView = imageView, let titleLabel = titleLabel else { return }
            
            let imageWidth = imageView.frame.size.width
            let imageHeight = imageView.frame.size.height
            let labelWidth = titleLabel.intrinsicContentSize.width
            let labelHeight = titleLabel.intrinsicContentSize.height
            let buttonWidth = bounds.width
            let minHeight = min(imageHeight, labelHeight)
            
            var imageEdgeInsets = UIEdgeInsets.zero
            var labelEdgeInsets = UIEdgeInsets.zero
            var contentEdgeInsets = UIEdgeInsets.zero
            
            switch style {
            case .left:
                contentVerticalAlignment = .center
                imageEdgeInsets = .zero
                labelEdgeInsets = UIEdgeInsets(top: 0, left: space, bottom: 0, right: -space)
                contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: space)
                
            case .right:
                contentVerticalAlignment = .center
                var offsetLabel = labelWidth + space / 2
                if labelWidth + imageWidth + space > buttonWidth {
                    offsetLabel = (titleLabel.frame.width) + space / 2
                }
                imageEdgeInsets = UIEdgeInsets(top: 0, left: offsetLabel, bottom: 0, right: -offsetLabel)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWidth + space / 2), bottom: 0, right: imageWidth + space / 2)
                contentEdgeInsets = UIEdgeInsets(top: 0, left: space / 2, bottom: 0, right: space / 2)
                
            case .top, .bottom:
                contentHorizontalAlignment = .center
                contentVerticalAlignment = .center
                
                var offsetLabel = labelWidth / 2
                if labelWidth + imageWidth + space > buttonWidth {
                    offsetLabel = (buttonWidth - imageWidth) / 2
                }
                if imageWidth + titleLabel.frame.width + space > buttonWidth {
                    offsetLabel = (buttonWidth - imageWidth) / 2
                }
                let halfHeight = (minHeight + space) / 2
                if style == .top {
                    imageEdgeInsets = UIEdgeInsets(top: -(labelHeight + space), left: offsetLabel, bottom: 0, right: -offsetLabel)
                    labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -(space + imageHeight), right: 0)
                } else {
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: offsetLabel, bottom: -(labelHeight + space), right: -offsetLabel)
                    labelEdgeInsets = UIEdgeInsets(top: -(space + imageHeight), left: -imageWidth, bottom: 0, right: 0)
                }
                contentEdgeInsets = UIEdgeInsets(top: halfHeight, left: 0, bottom: halfHeight, right: 0)
            }
            
            self.imageEdgeInsets = imageEdgeInsets
            self.titleEdgeInsets = labelEdgeInsets
            self.contentEdgeInsets = contentEdgeInsets
        }
    }
}
