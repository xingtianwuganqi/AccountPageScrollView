//
//  SingleViewController.swift
//  HeadSuspensionDemo
//
//  Created by jingjun on 2020/5/18.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

class SingleViewController: UIViewController {

    lazy var tableview : UITableView = {
        let tableview = UITableView(frame: .zero, style: UITableView.Style.grouped)
        tableview.estimatedRowHeight = 0
        tableview.estimatedSectionFooterHeight = 0
        tableview.estimatedSectionHeaderHeight = 0
        tableview.showsVerticalScrollIndicator = false
        tableview.showsHorizontalScrollIndicator = false
        tableview.separatorStyle = .none
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = UIColor.white
        return tableview
    }()
    var listScrollCallBack: ((UIScrollView) -> Void)?
    var listBeginCallBack: ((UIScrollView) -> Void)?
    init(block: ((UIScrollView) -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.listScrollCallBack = block
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableveiw()
    }
    
    func setTableveiw() {
        
        self.view.addSubview(self.tableview)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableview.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

extension SingleViewController: UITableViewDelegate ,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "第\(indexPath.row)行"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
extension SingleViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listScrollCallBack?(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.listBeginCallBack?(scrollView)
    }
}
