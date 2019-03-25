//
//  AccountListController.swift
//  App-720yun
//
//  Created by jingjun on 2019/2/18.
//  Copyright © 2019 720yun. All rights reserved.
//

import UIKit
import SnapKit

class AccountListController: UIViewController {

    let tableview = UITableView(frame: .zero, style: UITableView.Style.grouped).then { (view) in
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.estimatedRowHeight = 0
        view.estimatedSectionFooterHeight = 0
        view.estimatedSectionHeaderHeight = 0
    }
    
    var Black: ((UIScrollView) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableview)
        
        self.tableview.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        if #available(iOS 11.0, *) {
            self.tableview.contentInsetAdjustmentBehavior = .never
        } else {
            
        }
        
    }

}

extension AccountListController: UITableViewDelegate,UITableViewDataSource,AccountPageListViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "第\(indexPath.row)行"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.Black != nil {
            self.Black!(scrollView)
        }
    }
    
    func listScrollView() -> UIScrollView {
        return self.tableview
    }
    
    func listViewDidScrollCellBack(callback: @escaping (UIScrollView) -> ()) {
        self.Black = callback
    }
}
