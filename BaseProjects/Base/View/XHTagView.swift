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
    var titleColor: UIColor = .red
    ///选中之后的颜色
    var selectColor: UIColor = .red
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
    ///选中的标签背景颜色
    var selectBgColor: UIColor = .red
    ///边框的颜色
    var strokeColor: UIColor = .red
    ///边框是否是虚线 true=虚线 false=实线
    var isShape: Bool = true
    ///文字离标签间距
    var tagInsets: UIEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
    ///标签圆角
    var radius: CGFloat = 0
    ///默认选中第几个标签
    var selectIndex: Int = -1
    ///改变选择的标签
    var changeSelectIndex: Int = -1 {
        didSet {
            titleBtnClike(btn: titleBtns[changeSelectIndex])
        }
    }
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
    //上一个选中的标签按钮
    private var lastSelectTagBtn: UIButton?
    //上一个选中的标签View
    private var lastSelectBgView: UIView?
    
    //标签的button
    private var titleBtns: [UIButton] = []
    
    typealias selectTagBlack = (_ index: Int) -> ()
    private var selectTag: selectTagBlack?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        titleBtns.removeAll()
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
                bgView.frame.origin.y = (frame.size.height - titleBtnH) * 0.5
                bgView.layer.cornerRadius = radius
                bgView.layer.masksToBounds = true
                bgView.frame.size.width = titleBtn.frame.width + tagInsets.left + tagInsets.right
                
                if isShape {
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.strokeColor = strokeColor.cgColor
                    shapeLayer.fillColor = nil
                    shapeLayer.lineWidth = 2
                    shapeLayer.lineDashPattern = [4, 2]
                    let path = UIBezierPath(rect: bgView.bounds)
                    shapeLayer.path = path.cgPath
                    bgView.layer.addSublayer(shapeLayer)
                } else {
                    bgView.layer.borderWidth = 1
                    bgView.layer.borderColor = strokeColor.cgColor
                }
                
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
                
                titleBtns.append(titleBtn)
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
        
        //如果有默认选中的
        if selectIndex >= 0 {
            lastSelectTagBtn = titleBtns[selectIndex]
            lastSelectTagBtn?.setTitleColor(selectColor, for: .normal)
            lastSelectTagBtn?.setNeedsLayout()
            lastSelectBgView = tagViews[selectIndex]
            lastSelectBgView?.backgroundColor = selectBgColor
            changeStrokeColor(view: lastSelectBgView, color: selectBgColor)
        }
    }
    
    ///标签点击
    @objc private func titleBtnClike(btn: UIButton) {
        if lastSelectTagBtn != nil {
            lastSelectTagBtn?.setTitleColor(titleColor, for: .normal)
        }
        if lastSelectBgView != nil {
            lastSelectBgView?.backgroundColor = bgColor
            changeStrokeColor(view: lastSelectBgView, color: selectBgColor)
        }
        lastSelectTagBtn = btn
        lastSelectBgView = tagViews[btn.tag]
        
        btn.setTitleColor(selectColor, for: .normal)
        tagViews[btn.tag].backgroundColor = selectBgColor
        changeStrokeColor(view: tagViews[btn.tag], color: selectBgColor)
        
        selectTag?(btn.tag)
    }
    
    func changeStrokeColor(view: UIView?, color: UIColor) {
        if isShape {
            guard let sublayers = view?.layer.sublayers else { return }
            for layer in sublayers {
                // 检查是否是我们自定义添加的 layer，然后移除
                if let shapeLayer = layer as? CAShapeLayer {
                    shapeLayer.strokeColor = color.cgColor
                }
            }
        } else {
            view?.layer.borderColor = color.cgColor
        }
    }

}
