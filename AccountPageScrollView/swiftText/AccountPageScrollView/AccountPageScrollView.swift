//
//  AccountPageScrollView.swift
//  App-720yun
//
//  Created by jingjun on 2019/2/18.
//  Copyright © 2019 720yun. All rights reserved.
//

import UIKit

protocol AccountPageListViewDelegate : NSObjectProtocol {
    // 获取当前的列表
    func listScrollView() -> UIScrollView
    // 列表滚动的回调
    func listViewDidScrollCellBack(callback: @escaping (UIScrollView)->())
}

protocol AccountPageScrollViewDelegate: NSObjectProtocol {
    // 返回tableHeaderView
    func headerViewInPageScrollView(pageScrollView: AccountPageScrollView) -> UIView
    // 返回分页示图
    func pageViewInPageScrollView(pageScrollView: AccountPageScrollView) -> UIView
    // 返回listView
    func listViewInPageScrollView(pageScrollView: AccountPageScrollView) -> [AccountPageListViewDelegate]
    
    /**
     mainTableView开始滑动
     
     @param scrollView mainTableView
     */
    func mainTableViewWillBeginDragging(scrollView: UIScrollView)
    /**
     mainTableView滑动，用于实现导航栏渐变、头图缩放等
     
     @param scrollView mainTableView
     @param isMainCanScroll 是否到达临界点，YES表示到达临界点，mainTableView不再滑动，NO表示我到达临界点，mainTableView仍可滑动
     */
    func mainTableViewDidScroll(scrollView: UIScrollView,isMainCanScroll: Bool)
    /**
     mainTableView结束滑动
     
     @param scrollView mainTableView
     @param decelerate 是否将要减速
     */
    func mainTableViewDidEndDragging(scrollView: UIScrollView,willDecelerate: Bool)
    /**
     mainTableView结束滑动
     
     @param scrollView mainTableView
     */
    func mainTableViewDidEndDecelerating(scrollView: UIScrollView)
}

class AccountPageScrollView: UIView {
    
    weak var delegate : AccountPageScrollViewDelegate?
    var mainTableView : AccountPageTableView?
    // 吸顶临界点高度（默认值： 状态栏+导航栏）
    var ceilPointHeight: CGFloat = 0
    
    // 是否滑到临界点
    var isCriticalPoint : Bool = false
    // mainTableView 是否可以滑动
    var isMainCanScroll : Bool = true
    // listScrollView 是否可以滑动
    var isListCanScroll : Bool = false
    // 是否加载
    var isLoaded : Bool = false
    
    // 当前滑动的listView
    var currentListScrollView = UIScrollView()
    
    init(Delegate: AccountPageScrollViewDelegate) {
        super.init(frame: .zero)
        self.delegate = Delegate
        self.ceilPointHeight = naviHeight
        self.initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mainTableView?.frame = self.bounds
    }
    
    func initSubviews() {
        self.mainTableView = AccountPageTableView(frame: .zero, style: UITableView.Style.plain)
        self.mainTableView?.delegate = self
        self.mainTableView?.dataSource = self
        self.mainTableView?.separatorStyle = .none
        self.mainTableView?.showsVerticalScrollIndicator = false
        self.mainTableView?.showsHorizontalScrollIndicator = false
        self.mainTableView?.tableHeaderView = self.delegate?.headerViewInPageScrollView(pageScrollView: self)
        
        if #available(iOS 11.0, *) {
            self.mainTableView?.contentInsetAdjustmentBehavior = .never
        } else {
            
        }
        self.addSubview(self.mainTableView!)
        
        self.configListViewScroll()
    }
    
    func refreshHeaderView() {
        self.mainTableView?.tableHeaderView = self.delegate?.headerViewInPageScrollView(pageScrollView: self)
    }
    
    func reloadData() {
        self.isLoaded = true
        self.mainTableView?.reloadData()
    }
    
    func horizonScrollViewWillBeginScroll() {
        self.mainTableView?.isScrollEnabled = false
    }
    
    func horizonScrollViewDidEndedScroll() {
        self.mainTableView?.isScrollEnabled = true
    }
    
    func configListViewScroll (){
        _ = self.delegate?.listViewInPageScrollView(pageScrollView: self).map({ [weak self](delegate) in
            delegate.listViewDidScrollCellBack(callback: { (scrollview) in
                self?.listScrollViewDidScroll(scrollView: scrollview)
            })
        })
    }
    
    func listScrollViewDidScroll(scrollView: UIScrollView) {
        self.currentListScrollView = scrollView
        // 获取listScrollView 的偏移量
        let offsetY = scrollView.contentOffset.y
        
        // listScrollView 下滑至offsetY 小于0，禁止其滑动，让mainTableView 可下滑
        
        if offsetY <= 0 {
            self.isMainCanScroll = true
            self.isListCanScroll = false
            scrollView.contentOffset = .zero
            scrollView.showsVerticalScrollIndicator = false
        }else {
            if self.isListCanScroll {
                scrollView.showsVerticalScrollIndicator = true
                // 如果此时mainTableView 并没有滑动，则禁止listView滑动
                if self.mainTableView?.contentOffset.y == 0 {
                    self.isMainCanScroll = true
                    self.isListCanScroll = false
                    scrollView.contentOffset = .zero
                    scrollView.showsHorizontalScrollIndicator = false
                }else{
                    // 矫正mainTableView 的位置
                    let criticalPoint = self.mainTableView?.rect(forSection: 0).origin.y ?? 0 - self.ceilPointHeight
                    self.mainTableView?.contentOffset = CGPoint(x: 0, y: criticalPoint)
                }
                
            }else{
                scrollView.contentOffset = CGPoint.zero
            }
        }
    }
    
    @objc func mainScrollViewDidScroll(scrollView: UIScrollView) {
        // 获取mainScrollview 偏移量
        let offsetY = scrollView.contentOffset.y
        // 临界点
        let criticalPoint = (self.mainTableView?.rect(forSection: 0).origin.y ?? 0) - self.ceilPointHeight;
        
        //根据偏移量判断是否上滑到临界点
        if offsetY >= criticalPoint {
            self.isCriticalPoint = true
        }else {
            self.isCriticalPoint = false
        }
        
        if self.isCriticalPoint {
            // 上滑到临界点后，固定其位置
            scrollView.contentOffset = CGPoint(x: 0, y: criticalPoint)
            self.isMainCanScroll = false
            self.isListCanScroll = true
        }else{
            if self.isMainCanScroll {
                // 未到达临界点，mainScrollview 可滑动，需要重置所有listScrollView 的位置
                _ = self.delegate?.listViewInPageScrollView(pageScrollView: self).map { (delegate) in
                    let listScrollview = delegate.listScrollView()
                    listScrollview.contentOffset = .zero
                    listScrollview.showsVerticalScrollIndicator = false
                }
            }else{
//                // 未到达临界点，mainScrollview 不可滑动，固定其位置
//                scrollView.contentOffset = CGPoint(x: 0, y: criticalPoint)
                // 修正mainTableView 的位置
                let criticalPoint = (self.mainTableView?.rect(forSection: 0).origin.y ?? 0) - self.ceilPointHeight
                _ = self.delegate?.listViewInPageScrollView(pageScrollView: self).enumerated().map({ (index,delegate) in
                    let listScrollView = delegate.listScrollView()
                    if listScrollView.contentOffset.y != 0 {
                        self.mainTableView?.contentOffset = CGPoint(x: 0, y: criticalPoint)
                    }
                })
            }
        }
        
        self.delegate?.mainTableViewDidScroll(scrollView: scrollView, isMainCanScroll: self.isMainCanScroll)
    }
    
    
}

extension AccountPageScrollView : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isLoaded ? 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: nil)
        cell.selectionStyle = .none
        let pageView = self.delegate?.pageViewInPageScrollView(pageScrollView: self)
        pageView?.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH - self.ceilPointHeight)
        cell.contentView.addSubview(pageView!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenH - self.ceilPointHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.mainScrollViewDidScroll(scrollView: scrollView)
    
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.delegate?.mainTableViewWillBeginDragging(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.delegate?.mainTableViewDidEndDragging(scrollView: scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.mainTableViewDidEndDecelerating(scrollView: scrollView)
    }
    
}
