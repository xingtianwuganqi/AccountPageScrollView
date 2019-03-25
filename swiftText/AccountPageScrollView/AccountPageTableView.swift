//
//  AccountPageTableView.swift
//  App-720yun
//
//  Created by jingjun on 2019/2/18.
//  Copyright © 2019 720yun. All rights reserved.
//

import UIKit

class AccountPageTableView: UITableView,UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
