//
//  XHEmptyStateView.swift
//  无数据提示
//
//  Created by 张轩赫 on 2022/12/6.
//

import UIKit

extension UIView {
    func showEmptyState(imgName: String = "暂无回复", text: String = "暂无回复", topMargin: CGFloat = 50) {
        XHEmptyStateView.shrad.addEmptyStateView(imgName: imgName, text: text)
        self.addSubview(XHEmptyStateView.shrad)
        XHEmptyStateView.shrad.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(topMargin)
        }
    }
    func hiddenEmptyState() {
        XHEmptyStateView.shrad.hiddenEmptyStateView()
    }
    
}

class XHEmptyStateView: UIView {

    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .clear
        return bgView
    }()
    lazy var emptyImage: UIImageView = {
        let emptyImage = UIImageView(image: UIImage(named: "暂无回复"))
        return emptyImage
    }()
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor("9E9E9E")
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "暂无回复"
        return label
    }()
    
    static let shrad = XHEmptyStateView()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addEmptyStateView(imgName: String = "暂无回复", text: String = "暂无回复") {
        emptyImage.image = UIImage(named: imgName)
        label.text = text
        
        bgView.addSubview(emptyImage)
        emptyImage.snp.makeConstraints({ make in
            make.top.left.right.bottom.equalToSuperview()
        })
        
        bgView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyImage.snp.bottom).offset(16)
        }
        
        bgView.sizeToFit()
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        sizeToFit()
    }
    
    func hiddenEmptyStateView() {
        bgView.removeFromSuperview()
    }
    
}
