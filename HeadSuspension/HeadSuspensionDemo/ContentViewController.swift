//
//  ContentViewController.swift
//  HeadSuspensionDemo
//
//  Created by jingjun on 2020/5/18.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    lazy var pageController : UIPageViewController = {
        let backview = UIPageViewController.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        return backview
    }()
    
    var pages : [SingleViewController]?
    var scrollBlock: ((UIScrollView) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.pages = [
            SingleViewController.init(block: self.scrollBlock),
            SingleViewController.init(block: self.scrollBlock),
            SingleViewController.init(block: self.scrollBlock)
       ]
        setUI()
    }
    
    func setUI(){
        self.addChild(pageController)
        pageController.didMove(toParent: self)
        self.view.addSubview(pageController.view)
        pageController.view.frame = self.view.frame
        pageController.delegate = self
        pageController.dataSource = self
        guard let vc = self.pages?.first else {
            return
        }
        
        self.pageController.setViewControllers([vc], direction: .forward, animated: true) { (finish) in
            
        }
        
    }

}

extension ContentViewController: UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.index(controller: viewController)
        if index == 0 || index == NSNotFound {
            return nil
        }
        index -= 1
        if let pages = self.pages, pages.count > index {
            return pages[index]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.index(controller: viewController)
        guard let pages = self.pages else {
            return nil;
        }
        
        if index >= pages.count || index == NSNotFound {
            return nil
        }
        index += 1
        if pages.count > index {
            return pages[index]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        NotificationCenter.default.post(name: NSNotification.Name("beginHorizontalScroll"), object: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("beginHorizontalScroll"), object: false)
    }
    
    public func index(controller: UIViewController?) -> Int {
        guard let pages = self.pages else {
            return NSNotFound
        }
        var index = 0
        for page in pages {
            if controller == page {
                break
            }
            index += 1
        }
        return index
    }
}
