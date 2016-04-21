//
//  UILabelExt.swift
//  YWeibo
//
//  Created by 袁克强 on 16/4/20.
//  Copyright © 2016年 袁克强. All rights reserved.
//

import UIKit

extension UILabel{
    convenience init(color: UIColor, fontSize: CGFloat){
        self.init()
        textColor = color
        font = UIFont.systemFontOfSize(fontSize)
    }
}
