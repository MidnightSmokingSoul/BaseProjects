//
//  UIViewController+Extension.swift
//  UIViewController+Extension
//
//  Created by 张轩赫 on 2021/1/12.
//

import UIKit

extension UIViewController {
    
    @objc class func initByName(storyboardName: String) -> Self {
        return instantiateFromStoryboardHelper(storyboardName: storyboardName, storyboardId: nameOfClass)
    }
    private class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        return controller
    }
    
    class var nameOfClass: String {
        NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    func setLeftTitle(title: String = "", imagePadding: CGFloat = 10) {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: self.navigationController?.navigationBar.frame.height ?? 44))
        if #available(iOS 15.0, *) {
            var conf = UIButton.Configuration.plain()
            conf.imagePlacement = .leading
            conf.imagePadding = imagePadding
            let button = UIButton(configuration: conf, primaryAction: nil)//UIButton(type: .custom)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
            button.setTitleColor(.black, for: .normal)
            button.setImage(UIImage(named: "返回"), for: .normal)
            button.setTitle(title, for: .normal)
            button.sizeToFit()
            button.center.y = containerView.center.y
            containerView.addSubview(button)
        } else {
            let button = UIButton(type: .custom)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
            button.setTitleColor(.black, for: .normal)
            button.setImage(UIImage(named: "返回"), for: .normal)
            button.setTitle(title, for: .normal)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: imagePadding, bottom: 0, right: -imagePadding)
            button.sizeToFit()
            button.center.y = containerView.center.y
            containerView.addSubview(button)
        }
        containerView.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: containerView)
    }
    
    @objc func menuTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
