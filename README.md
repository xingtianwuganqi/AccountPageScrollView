# AccountPageScrollView
iOS Swift简单的吸顶实现，仿抖音、简书、微博个人主页

HeadSuspensionDemo: 根据自己的思路实现置顶效果
 tableview + pageViewController 实现置顶效果
```
/*
思路：
向上滑动：固定listTable,到顶部之后固定主table
向下滑动：在顶部时固定主table，滑动listTable，listTable滑到0点后，不固定主table，固定listTable
左右切换listTable时，固定主table
主table没置顶时，下拉listTable，主table固定
*/
```

效果图
![gif5.gif](https://upload-images.jianshu.io/upload_images/8042403-94a49179e160a0c7.gif?imageMogr2/auto-orient/strip)

实现思路
1.整体是tableview，全部由tableview 的tableHeaderView和一行cell组成，tableview 只有一行，行高从导航栏的底部到view的底部
如图
![1181553522063_.pic.jpg](https://upload-images.jianshu.io/upload_images/8042403-bae3d839ccde4067.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![1191553522121_.pic.jpg](https://upload-images.jianshu.io/upload_images/8042403-75860079b967b1ae.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

绿色部分是tableview的 tableHeaderView
tableview 要允许多手势滑动
```
import UIKit

class AccountPageTableView: UITableView,UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
```
2.在tableview 的一行cell中添加顶部的横行视图和下面的列表视图
####  2.1先制定两个协议
```
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

```
2.2 在代理方法中返回视图
```
self.pageView.addSubview(self.categoryView) // 横行的view
self.pageView.addSubview(self.scrollView)// 横向滚动的scrollview
```
```
extension AccountPageViewController : AccountPageScrollViewDelegate {
   
    //返回tableviewheaderview
    func headerViewInPageScrollView(pageScrollView: AccountPageScrollView) -> UIView {
        return self.headerView
    }
    // 返回pageview
    func pageViewInPageScrollView(pageScrollView: AccountPageScrollView) -> UIView {
        return self.pageView
    }
    
    func listViewInPageScrollView(pageScrollView: AccountPageScrollView) -> [AccountPageListViewDelegate] {
        
        if self.childVCs.count == 0 {
            self.childVCs = [one,two]
        }
        
        return self.childVCs
        
    }
}
```
返回的pageview 就是一行cell的contentview
```
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
}
```
3.处理tableview滚动的方法
```
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
```
###4.处理下面listview 滚动
```
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
```
