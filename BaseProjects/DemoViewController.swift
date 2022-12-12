//
//  DemoViewController.swift
//  BaseProjects
//
//  Created by mac on 2022/12/8.
//

import UIKit

class DemoViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setLeftTitle(title: "公司公司返回返回")
        view.backgroundColor = .orange
        
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.backgroundColor = .opaqueSeparator
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
    }
    
}

extension DemoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo = DemoViewController()
        navigationController?.pushViewController(demo, animated: true)
    }
}
