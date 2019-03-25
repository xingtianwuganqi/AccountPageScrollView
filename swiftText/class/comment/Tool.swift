//
//  Tool.swift
//  swiftText
//
//  Created by jingjun on 2018/8/28.
//  Copyright © 2018年 景军. All rights reserved.
//

import UIKit

class Tool: NSObject {
    static let shared = Tool()
    private override init() {
        
    }
    
    func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let normalText: NSString = textStr as NSString
        let size = CGSize(width: ceil(width), height: CGFloat(MAXFLOAT))//CGSizeMake(width,1000)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        return ceil(stringSize.height)
    }
    
    func getSpaceLabelHeight(textStr:String,font:UIFont,width:CGFloat,space: CGFloat,paragraph: CGFloat) -> CGFloat {
        
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = space //调整行间距
        let values = [font,paragraphStyle,paragraph] as [Any]
        let dis = [kCTFontAttributeName as! NSCopying,kCTParagraphStyleAttributeName as! NSCopying,kCTKernAttributeName as! NSCopying]
        let dic = NSDictionary(objects: values, forKeys: dis)
        let normalText: NSString = textStr as NSString
        let size = CGSize(width: ceil(width), height: CGFloat(MAXFLOAT))
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        return ceil(stringSize.height)
    }
    
    
}
