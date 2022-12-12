//
//  XHTagView.swift
//  不规则标签
//
//  Created by 张轩赫 on 2022/12/5.
//

import UIKit
import SnapKit

enum Direction {
    case horizontal
    case vertical
}

class XHTagView: UIView {
    
    ///标签数组
    var tags: [String] = [] {
        didSet {
            relaodData()
        }
    }
    ///展示方向
    var direction: Direction = .vertical
    ///字体颜色
    var titleColor: UIColor = .black
    ///文字字体
    var titleFont: UIFont = UIFont.systemFont(ofSize: 12)
    ///标签离背景左右间距
    var padding: CGFloat = 15 {
        didSet {
            titleBtnX = padding
        }
    }
    ///标签之间间距
    var margin: CGFloat = 15
    ///标签背景颜色
    var bgColor: UIColor = .white
    ///文字离标签间距
    var tagInsets: UIEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
    ///标签圆角
    var radius: CGFloat = 0
    
    /*
     * 只有上下排列才需要
     */
    
    ///标签的高度
    var titleBtnH: CGFloat = 25
    ///view的宽度 (如果使用SnapKit布局必须给定TagView的宽度)
    var tagViewW: CGFloat = 0
    
    //第一个标签的开始x
    private var titleBtnX: CGFloat = 15
    //标签的y
    private var titleBtnY: CGFloat = 0
    ///获取上下排列时 view的高度
    private (set) var viewH: CGFloat = 0
    
    //view上的ScrollView
    private var bgScrollView: UIScrollView?
    //标签views
    private var tagViews: [UIView] = []
    
    typealias selectTagBlack = (_ index: Int) -> ()
    private var selectTag: selectTagBlack?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///左右展示(可滑动) 上下展示(不可滑动)
    func didSelectTagCallback(selectTag: @escaping selectTagBlack) {
        self.selectTag = selectTag
    }
    
    //刷新数据
    private func relaodData() {
        setupTopic(tags: tags)
    }
    
    //MARK: 设置话题
    private func setupTopic(tags: [String]) {
        bgScrollView?.removeFromSuperview()
        bgScrollView = UIScrollView()
        bgScrollView?.backgroundColor = .clear
        bgScrollView?.showsVerticalScrollIndicator = false
        bgScrollView?.showsHorizontalScrollIndicator = false
        addSubview(bgScrollView!)
        bgScrollView?.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        addLabel(tags: tags)
    }
    private func addLabel(tags: [String]) {
        tagViews.removeAll()
        if tags.count == 0 {
            return
        }
        if tags.count > 0 {
            for i in 0..<tags.count {
                let bgView = UIView()
                bgView.backgroundColor = bgColor
                
                let titleBtn = UIButton(type: .custom)
                //设置按钮的样式
                titleBtn.setTitleColor(titleColor, for: .normal)
                titleBtn.setTitle(tags[i], for: .normal)
                titleBtn.contentMode = .center
                titleBtn.titleLabel?.font = titleFont
                titleBtn.tag = i
                titleBtn.addTarget(self, action: #selector(titleBtnClike(btn:)), for: .touchUpInside)
                titleBtn.sizeToFit()
                
                bgView.tag = i
                bgView.frame.size.height = titleBtnH
                bgView.frame.origin.y = 0
                bgView.layer.cornerRadius = radius
                bgView.layer.masksToBounds = true
                bgView.frame.size.width = titleBtn.frame.width + tagInsets.left + tagInsets.right
                
                if direction == .vertical {
                    if i == 0 {
                        bgView.frame.origin.x = padding
                    } else {
                        bgView.frame.origin.x = tagViews[i - 1].frame.maxX + margin
                    }
                } else {
                    let titleBtnW = bgView.frame.width
                    //判断按钮是否超过屏幕的宽
                    if titleBtnX + titleBtnW > (tagViewW == 0 ? frame.width : tagViewW) - (padding * 2) {
                        titleBtnX = padding
                        titleBtnY += titleBtnH + margin
                    }
                    //设置按钮的位置
                    bgView.frame = CGRect(x: titleBtnX, y: titleBtnY, width: titleBtnW, height: titleBtnH)
                    titleBtnX += titleBtnW + margin
                }
                
                bgView.addSubview(titleBtn)
                titleBtn.snp.makeConstraints { make in
                    make.top.equalTo(bgView).inset(tagInsets.top)
                    make.bottom.equalTo(bgView).inset(tagInsets.bottom)
                    make.left.equalTo(bgView).inset(tagInsets.left)
                    make.right.equalTo(bgView).inset(tagInsets.right)
                }
                tagViews.append(bgView)
                bgScrollView?.addSubview(bgView)
            }
        }
        bgScrollView?.contentSize = CGSize(width: (tagViews.last?.frame.maxX ?? 0) + padding, height: 0)
        frame.size.height = tagViews.last?.frame.maxY ?? 0
        viewH = tagViews.last?.frame.maxY ?? 0
    }
    
    ///标签点击
    @objc private func titleBtnClike(btn: UIButton) {
        selectTag?(btn.tag)
    }

}
