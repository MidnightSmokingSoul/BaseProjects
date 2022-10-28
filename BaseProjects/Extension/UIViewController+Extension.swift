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
}
