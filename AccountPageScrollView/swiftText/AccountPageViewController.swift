//
//  AccountPageViewController.swift
//  App-720yun
//
//  Created by jingjun on 2019/2/18.
//  Copyright © 2019 720yun. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class AccountPageViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    var pageScrollView : AccountPageScrollView?
    var pageView : UIView = UIView(frame: .zero).then { (view) in
        
    }
    var categoryView : AccountTitleView = AccountTitleView().then { (view) in
        view.frame = CGRect(x: 0, y: 0, width: ScreenW, height: 51)
    }
    var scrollView : UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 51, width: ScreenW, height: ScreenH - naviHeight - 51)).then { (scrollView) in
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .blue
    }
    var headerView : UIView = UIView(frame: .zero).then { (view) in
        view.frame = CGRect(x: 0, y: 0, width: ScreenW, height: 400)
        view.backgroundColor = .green
    }
    
    let one = AccountListController().then { (vc) in
        vc.view.backgroundColor = .yellow
    }
    
    let two = AccountListController().then { (vc) in
        vc.view.backgroundColor = .white

    }
    
    var childVCs: [AccountListController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageScrollView = AccountPageScrollView.init(Delegate: self)
        self.view.addSubview(self.pageScrollView!)
        self.pageScrollView?.reloadData()
        self.pageScrollView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(view)
        })
        
        self.pageView.addSubview(self.categoryView) // 横行的view
        self.pageView.addSubview(self.scrollView)// 横向滚动的scrollview
        self.scrollView.delegate = self
        self.addButtonClick()
        
        if self.childVCs.count == 0 {
            self.childVCs = [one,two]
        }
        
        
        _ = self.childVCs.enumerated().map { (index,viewcontroller) in
            self.addChildViewController(viewcontroller)
            self.scrollView.addSubview(viewcontroller.view)
            viewcontroller.view.frame = CGRect(x: CGFloat(index) * ScreenW, y: 0, width: ScreenW, height: ScreenH - naviHeight - 51)
        }
        scrollView.contentSize = CGSize(width: ScreenW * CGFloat(self.childVCs.count), height: ScreenH - naviHeight - 51)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollViewDidMainScroll((self.pageScrollView?.mainTableView!)!)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //退出时设置istranslucent
        
        self.navigationController?.navigationBar.barStyle = .default
        
        navigationController?.navigationBar.Mg_reset()
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        
    }
    
    func addButtonClick() {
        //默认作品按钮选中
        self.categoryView.panoTitle.isSelected = true
        self.categoryView.panoTitle.rx.tap.subscribe(onNext: { [weak self](_) in
            self?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }).disposed(by: disposeBag)
        
        self.categoryView.collectionTitle.rx.tap.subscribe(onNext: { [weak self](_) in
            self?.scrollView.setContentOffset(CGPoint(x: ScreenW, y: 0), animated: true)
        }).disposed(by: disposeBag)
    }
    
}
extension AccountPageViewController : AccountPageScrollViewDelegate {
   
    
    func headerViewInPageScrollView(pageScrollView: AccountPageScrollView) -> UIView {
        return self.headerView
    }
    
    func pageViewInPageScrollView(pageScrollView: AccountPageScrollView) -> UIView {
        return self.pageView
    }
    
    func listViewInPageScrollView(pageScrollView: AccountPageScrollView) -> [AccountPageListViewDelegate] {
        
        if self.childVCs.count == 0 {
            self.childVCs = [one,two]
        }
        
        return self.childVCs
        
    }
    
    func mainTableViewWillBeginDragging(scrollView: UIScrollView) {
        // 导航栏的显示与隐藏
    }
    
    func mainTableViewDidScroll(scrollView: UIScrollView, isMainCanScroll: Bool) {
        self.scrollViewDidMainScroll(scrollView)
    }
    
    func mainTableViewDidEndDragging(scrollView: UIScrollView, willDecelerate: Bool) {
        
    }
    
    func mainTableViewDidEndDecelerating(scrollView: UIScrollView) {
        
    }
}

extension AccountPageViewController : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.pageScrollView?.horizonScrollViewWillBeginScroll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageScrollView?.horizonScrollViewDidEndedScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.pageScrollView?.horizonScrollViewDidEndedScroll()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            // 左边的距离加上移动的相对位置
            self.categoryView.line.frame = CGRect(x: ScreenW / 2 - 77 + (scrollView.contentOffset.x * 104 / ScreenW), y: 50, width: 50, height: 2)
            
            if scrollView.contentOffset.x == 0 {
                self.categoryView.panoIsSelected = true
                
            }else if scrollView.contentOffset.x == ScreenW{
                self.categoryView.panoIsSelected = false
            }
            
            
        }
    }
}
extension AccountPageViewController {
    func scrollViewDidMainScroll(_ scrollView: UIScrollView) {
        let minAlphaOffset : CGFloat = 0
        let maxAlphaOffset : CGFloat = 200 + naviHeight
        
        let offset = scrollView.contentOffset.y
        let alpha = (offset - minAlphaOffset)/(maxAlphaOffset - minAlphaOffset)
        
        let color = UIColor.white
        let offsetY: CGFloat = scrollView.contentOffset.y
    
        
        if offsetY < 50 {
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            navigationItem.title = ""
            self.navigationController?.navigationBar.Mg_setBackgroundColor(backgroundColor: UIColor.clear.withAlphaComponent(0))

            
        }else if offsetY < (200 + naviHeight) {
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.Mg_setBackgroundColor(backgroundColor: color.withAlphaComponent(alpha))
            navigationItem.title = ""
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()

            
        } else {
            self.navigationController?.navigationBar.Mg_setBackgroundColor(backgroundColor: color.withAlphaComponent(1))
            self.navigationController?.navigationBar.barStyle = .default
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController?.navigationBar.shadowImage = nil

            
        }
    }
}
