//
//  ContentCell.swift
//  HeadSuspensionDemo
//
//  Created by jingjun on 2020/5/18.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {
    
    public lazy var controller : ContentViewController = {
        let controller = ContentViewController()
        return controller
    }()
    
    var contentBlock: ((UIScrollView) -> Void)?
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?,begin: ((UIScrollView) -> Void)?,block: ((UIScrollView) -> Void)?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        controller.beginScroll = begin
        controller.scrollBlock = block
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        contentView.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        controller.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
