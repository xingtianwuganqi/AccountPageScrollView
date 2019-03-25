//
//  HomePageController.swift
//  swiftText
//
//  Created by jingjun on 2019/2/19.
//  Copyright © 2019 景军. All rights reserved.
//

import UIKit
import ReplayKit

class HomePageController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let accountpage = AccountPageViewController()
        self.navigationController?.pushViewController(accountpage, animated: true)
//        self.startRecord()
    }

    func startRecord() {
        if !RPScreenRecorder.shared().isRecording {
            if #available(iOS 11.0, *) {
                
                RPBroadcastActivityViewController.load { (broadcastActivityViewController, error) in
                    guard let broadcastController = broadcastActivityViewController else {
                        return
                    }
                    
                    broadcastController.delegate = self
                    broadcastController.modalPresentationStyle = UIModalPresentationStyle.popover
                    
                    //                    broadcastController.popoverPresentationController?.sourceRect = self.panoContainer.frame
                    //                    broadcastController.popoverPresentationController?.sourceView = self.panoContainer
                    self.present(broadcastController, animated: true, completion: nil)
                }
                
//                RPBroadcastActivityViewController.load(withPreferredExtension: "com.720yun.Yun-ios.App-720yunRecord") { (broadcastActivityViewController, error) in
//                    guard error == nil else {
//                        print(error?.localizedDescription ?? "error")
//                        return
//                    }
//                    
//                    guard let broadcastController = broadcastActivityViewController else {
//                        return
//                    }
//                    
//                    broadcastController.delegate = self
//                    broadcastController.modalPresentationStyle = UIModalPresentationStyle.popover
//                    
////                    broadcastController.popoverPresentationController?.sourceRect = self.panoContainer.frame
////                    broadcastController.popoverPresentationController?.sourceView = self.panoContainer
//                    self.present(broadcastController, animated: true, completion: nil)
//                }
            } else {
                print("您的手机不支持屏幕录制")
            }
        }
    }

}
extension HomePageController : RPBroadcastActivityViewControllerDelegate,RPBroadcastControllerDelegate {
    func broadcastActivityViewController(_ broadcastActivityViewController: RPBroadcastActivityViewController, didFinishWith broadcastController: RPBroadcastController?, error: Error?) {
        broadcastActivityViewController.dismiss(animated: true, completion: nil)
        print("完成设置，开始录制")
    }
    
    
}
