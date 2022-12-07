//
//  ViewController.swift
//  BaseProjects
//
//  Created by mac on 2022/10/28.
//

import UIKit

class ViewController: UIViewController {

    let tags = ["這是", "個真實的", "故事", "每當朋友抱怨著", "婚姻", "如何讓", "彼此受傷", "折磨", "美好殆盡", "夢想幻滅", "我", "就回憶起", "一段往事"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tag1 = TagView(frame: CGRect(x: 0, y: 150, width: view.frame.width, height: 25))
        tag1.tags = tags
//        tag1.backgroundColor = .orange
        tag1.bgColor = .blue
        tag1.radius = 5
        tag1.titleColor = .white
        tag1.setHorizontalScroll { index in
            print(index)
        }
        view.addSubview(tag1)
        
        let tag2 = TagView(frame: CGRect(x: 0, y: 300, width: view.frame.width, height: 30))
        tag2.tags = tags
//        tag2.backgroundColor = .blue
        tag2.bgColor = .orange
        tag2.radius = 5
        tag2.titleColor = .black
        tag2.titleBtnH = 25
        tag2.setVerticalScroll { index in
            print(index)
        }
        tag2.frame.size.height = tag2.viewH
        view.addSubview(tag2)
    }
    
}

