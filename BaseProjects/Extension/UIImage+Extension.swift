//
//  UIImage+Extension.swift
//  UIImage+Extension
//
//  Created by 张轩赫 on 2021/1/12.
//

import UIKit

extension UIImage {
    
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.addRect(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func imageWithSize(size:CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth: CGFloat = size.width / self.size.width
        let aspectHeight: CGFloat = size.height / self.size.height
        let aspectRatio: CGFloat = max(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) * 0.5
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) * 0.5
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        self.draw(in: scaledImageRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    //创建二维码图片
    class func createQRForString(qrString: String?, qrImageName: String?) -> UIImage? {
        if let sureQRString = qrString {
            let stringData = sureQRString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue("L", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter.outputImage
            
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            
            let codeImage = UIImage(ciImage: (colorFilter.outputImage?.transformed(by: CGAffineTransform(scaleX: 5, y: 5)))!)
            if let iconImage = UIImage(named: qrImageName ?? "") {
                let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)
                
                codeImage.draw(in: rect)
                let avatarSize = CGSize(width: rect.size.width * 0.25, height: rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
    }
    
}
