//
//  BaseScrollView.swift
//  swiftText
//
//  Created by jingjun on 2018/12/21.
//  Copyright © 2018 景军. All rights reserved.
//

import UIKit

@objc public protocol JXPagingMainTableViewGestureDelegate {
    //如果headerView（或其他地方）有水平滚动的scrollView，当其正在左右滑动的时候，就不能让列表上下滑动，所以有此代理方法进行对应处理
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
}

class BaseScrollView: UIScrollView,UIGestureRecognizerDelegate {
    open weak var gestureDelegate: JXPagingMainTableViewGestureDelegate?


    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureDelegate != nil {
            return gestureDelegate!.mainTableViewGestureRecognizer(gestureRecognizer, shouldRecognizeSimultaneouslyWith:otherGestureRecognizer)
        }else {
            return gestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder()) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder())
        }
    }

}
