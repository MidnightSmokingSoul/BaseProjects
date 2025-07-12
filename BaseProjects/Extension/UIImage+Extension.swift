//
//  UIImage+Extension.swift
//  UIImage+Extension
//
//  Created by 张轩赫 on 2021/1/12.
//

import UIKit
import CoreImage

extension UIImage {
    
    /// 生成纯色图片（1x1像素）
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    /// 按指定大小缩放图片，保持长宽比并居中
    func imageWithSize(size: CGSize) -> UIImage {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        let scaledWidth = self.size.width * aspectRatio
        let scaledHeight = self.size.height * aspectRatio
        let x = (size.width - scaledWidth) / 2
        let y = (size.height - scaledHeight) / 2
        let scaledRect = CGRect(x: x, y: y, width: scaledWidth, height: scaledHeight)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.draw(in: scaledRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage ?? self
    }
    
    /// 根据字符串生成二维码图片，支持添加中间小图标
    /// - Parameters:
    ///   - qrString: 用于生成二维码的字符串
    ///   - qrImageName: 中间图标图片名（可选）
    /// - Returns: 生成的二维码图片
    class func createQRForString(qrString: String?, qrImageName: String?) -> UIImage? {
        guard let qrString = qrString,
              let stringData = qrString.data(using: .utf8),
              let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        
        qrFilter.setValue(stringData, forKey: "inputMessage")
        qrFilter.setValue("L", forKey: "inputCorrectionLevel") // 纠错级别 L/M/Q/H
        
        guard let qrCIImage = qrFilter.outputImage else { return nil }
        
        // 黑白颜色滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        guard let outputImage = colorFilter.outputImage else { return nil }
        
        // 放大二维码
        let scaleTransform = CGAffineTransform(scaleX: 5, y: 5)
        let scaledImage = UIImage(ciImage: outputImage.transformed(by: scaleTransform))
        
        // 如果有中间图标，则合成
        if let iconImageName = qrImageName,
           let iconImage = UIImage(named: iconImageName) {
            let size = scaledImage.size
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            scaledImage.draw(in: CGRect(origin: .zero, size: size))
            
            let iconSize = CGSize(width: size.width * 0.25, height: size.height * 0.25)
            let iconOrigin = CGPoint(x: (size.width - iconSize.width)/2,
                                     y: (size.height - iconSize.height)/2)
            iconImage.draw(in: CGRect(origin: iconOrigin, size: iconSize))
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resultImage
        }
        
        return scaledImage
    }
}
