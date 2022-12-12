//
//  ViewController.swift
//  BaseProjects
//
//  Created by mac on 2022/10/28.
//

import UIKit

class ViewController: BaseViewController {

    let tags = ["這是", "個真實的", "故事", "每當朋友抱怨著", "婚姻", "如何讓", "彼此受傷", "折磨", "美好殆盡", "夢想幻滅", "我", "就回憶起", "一段往事"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "首页"
        view.backgroundColor = .brown
        let tag1 = XHTagView(frame: CGRect(x: 0, y: 150, width: view.frame.width, height: 25))
        tag1.bgColor = .blue
        tag1.radius = 5
        tag1.titleColor = .white
        tag1.didSelectTagCallback { index in
            print(index)
            let demo = DemoViewController()
            self.navigationController?.pushViewController(demo, animated: true)
        }
        view.addSubview(tag1)
        
        tag1.tags = tags
        
        
        let tag2 = XHTagView(frame: CGRect(x: 0, y: 300, width: view.frame.width, height: 30))
        tag2.tagViewW = view.frame.width
        tag2.bgColor = .orange
        tag2.radius = 5
        tag2.padding = 25
        tag2.titleColor = .black
        tag2.titleBtnH = 25
        tag2.direction = .horizontal
        tag2.didSelectTagCallback { index in
            print(index)
        }
        
        view.addSubview(tag2)
        tag2.tags = tags
        tag2.frame.size.height = tag2.viewH

    }
    
}

