//
//  AccountTitleView.swift
//  App-720yun
//
//  Created by jingjun on 2019/2/21.
//  Copyright © 2019 720yun. All rights reserved.
//

import UIKit

class AccountTitleView: UIView {
    
    let panoTitle = UIButton(type: .custom).then { (button) in
        button.setTitleColor(.black, for: .selected)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("作品", for: .normal)
        
    }
    
    let collectionTitle = UIButton(type: .custom).then { (button) in
        button.setTitleColor(.black, for: .selected)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("收藏", for: .normal)
    }
    
    let line = UIView().then { (view) in
        view.backgroundColor = .black
        view.frame = CGRect(x: ScreenW / 2 - 52 - 25, y: 50, width: 50, height: 2)
    }
    
    let bottomLine = UIView().then { (view) in
        view.backgroundColor = .gray
    }
    
    var panoIsSelected : Bool = false {
        willSet {
            
            if newValue == true {
                self.panoTitleIsSelected(selected: true)
            }else{
                self.panoTitleIsSelected(selected: false)
            }
            
        }
        didSet {
            
        }
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 52))
        self.addSubview(panoTitle)
        self.addSubview(collectionTitle)
        self.addSubview(bottomLine)
        self.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        panoTitle.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 103, height: 50))
            make.top.equalToSuperview().offset(1)
            make.left.equalToSuperview().offset(ScreenW / 2 - 105)
        }
        
        collectionTitle.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 103, height: 50))
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(ScreenW / 2)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
    
    func panoTitleIsSelected(selected: Bool) {
        if selected {
            self.panoTitle.isSelected = true
            self.collectionTitle.isSelected = false
            
        }else{
            self.panoTitle.isSelected = false
            self.collectionTitle.isSelected = true
            
        }
    }
    
    

}
