//
//  BaseViewController.swift
//  HeadSuspensionDemo
//
//  Created by jingjun on 2020/5/18.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(ViewController.init(), animated: true)
    }

}
