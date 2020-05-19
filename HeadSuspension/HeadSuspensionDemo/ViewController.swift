//
//  ViewController.swift
//  HeadSuspensionDemo
//
//  Created by jingjun on 2020/5/18.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

let ScreenW = UIScreen.main.bounds.size.width
let ScreenH = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    
    lazy var headView : UIView = {
        let headView = UIView()
        headView.frame = CGRect(x: 0, y: 0, width: ScreenW, height: 100)
        headView.backgroundColor = .gray
        return headView
    }()
    
    lazy var tableview : AccountPageTableView = {
        let tableview = AccountPageTableView(frame: .zero, style: UITableView.Style.grouped)
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
    
    var isTopSuspension: Bool = false
    var listBeginScrollBlock: ((UIScrollView) -> Void)?
    var listScrollDidScrollBlock: ((UIScrollView) -> Void)?
    
    weak var currentScrollView: UIScrollView?
    var beginContentOffset: CGFloat = 0
    var listBeginContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        setTableveiw()
        
        listScrollBlock()
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollNotification(notifi:)), name: NSNotification.Name("beginHorizontalScroll"), object: nil)
    }
    
    func setTableveiw() {
        
        if #available(iOS 11.0, *) {
            tableview.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.view.addSubview(self.tableview)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            tableview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 64).isActive = true
        }
        tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableview.tableHeaderView = headView
    }
    
    deinit {
        print("Deinit")
    }
}

extension ViewController: UITableViewDelegate ,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell") as? ContentCell
        if cell == nil {
            cell = ContentCell.init(style: .default, reuseIdentifier: "ContentCell", begin: self.listBeginScrollBlock, block: self.listScrollDidScrollBlock)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backview = UIView()
        backview.backgroundColor = .blue
        return backview
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenH - 64 - 50
    }
}

extension ViewController {
    /*
     思路：
     向上滑动：固定listTable,到顶部之后固定主table
     向下滑动：在顶部时固定主table，滑动listTable，listTable滑到0点后，不固定主table，固定listTable
     左右切换listTable时，固定主table
     主table没置顶时，下拉listTable，主table固定
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topContentOffset = self.tableview.rect(forSection: 0).origin.y
        print("topContentOffset：",topContentOffset)
        if scrollView.contentOffset.y > beginContentOffset { // 向上滑
            if scrollView.contentOffset.y >= topContentOffset { // 到顶了
                self.isTopSuspension = true
                // 固定主tableview
                scrollView.setContentOffset(CGPoint(x: 0,y: topContentOffset), animated: false)
            }else{
                self.isTopSuspension = false
                guard let currentScroll = self.getCurrentList() else {
                    return
                }
                // 固定listTableview
                if currentScroll.contentOffset.y >= 0 {
                    currentScroll.setContentOffset(.zero, animated: false)
                }
            }
        }else if scrollView.contentOffset.y < beginContentOffset { // 向下滑
            // 如果是置顶状态
            if isTopSuspension {
                guard let currentScroll = self.getCurrentList() else {
                    return
                }
                if currentScroll.contentOffset.y > 0 {
                    // 固定主tableview
                    scrollView.setContentOffset(CGPoint(x: 0,y: topContentOffset), animated: false)
                }else{
                    isTopSuspension = false
                    // 固定listTableview
                    if currentScroll.contentOffset.y <= 0 {
                        currentScroll.setContentOffset(.zero, animated: false)
                    }
                }
            }else{
                guard let currentScroll = self.getCurrentList() else {
                    return
                }
                // 固定listTableview
                if currentScroll.contentOffset.y <= 0 {
                    currentScroll.setContentOffset(.zero, animated: false)
                }else if currentScroll.contentOffset.y > 0 { // 如果tableview没在顶部，list也没在顶部,tableview 固定
                    self.tableview.setContentOffset(CGPoint(x: 0, y: beginContentOffset), animated: false)
                }
            }
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.beginContentOffset = scrollView.contentOffset.y
    }
}

extension ViewController {
    func  listScrollBlock() {
        
        self.listBeginScrollBlock = { [weak self](scrollview) in
            self?.listBeginContentOffset = scrollview.contentOffset.y
        }
        
        self.listScrollDidScrollBlock = { [weak self](scrollview) in
            guard let `self` = self else { return }
            print("listScrollDidScrollBlock：",scrollview.contentOffset.y)
            if self.isTopSuspension { // 如果已经到顶了
                if scrollview.contentOffset.y <= 0 {
                    scrollview.setContentOffset(.zero, animated: false)
                }
            }else{
                //如果tableview 没在顶部，list滚动到了0点，tableview可以滚动
                if scrollview.contentOffset.y > self.listBeginContentOffset {// 向上滑，list一直0点
                    print("listBeginContentOffset：",self.listBeginContentOffset)
                    scrollview.setContentOffset(.zero, animated: false)
                }else{
                    // 固定listTableview
                    if scrollview.contentOffset.y <= 0 {
                        scrollview.setContentOffset(.zero, animated: false)
                    }
                }
            }
        }
    }
    // 滑动子视图是禁止tableview 滚动
    @objc func scrollNotification(notifi: Notification) {
        guard let begin = notifi.object as? Bool else{
            return
        }
        self.tableview.isScrollEnabled = !begin
        if !begin { // 切换之后刷新当前开始位置
            self.listBeginContentOffset = self.getCurrentList()?.contentOffset.y ?? 0.0
        }
    }
    
    func getCurrentList() -> UIScrollView? {
        guard let cell = tableview.cellForRow(at: IndexPath(row: 0, section: 0)) as? ContentCell else {
            return nil
        }
        guard let currentList = cell.controller.pageController.viewControllers?.first as? SingleViewController else {
            return nil
        }
        
        return currentList.tableview
    }
}

class AccountPageTableView: UITableView,UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
