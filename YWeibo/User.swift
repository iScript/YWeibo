//
//  User.swift
//  YWeibo
//
//  Created by 袁克强 on 16/4/20.
//  Copyright © 2016年 袁克强. All rights reserved.
//

import UIKit

class User: NSObject {
    /// 用户代号
    var id: Int = 0
    /// 友好显示名称
    var name: String?
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
        {
        didSet{
            imageURL = NSURL(string: profile_image_url!)
        }
    }
    /// 时候是认证, true是, false不是
    var verified: Bool = false
    /// 用户的认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified_type: Int = -1
    /// 认证图标
    var verified_img: UIImage?{
        switch verified_type{
        case 0:
            return UIImage(named: "avatar_vip")
        case 2, 3, 5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:
            return UIImage(named: "avatar_grassroot")
        default:
            return nil
        }
    }
    
    /// 微博来源
    // <a>.....</a>
    var source: String?{
        didSet{
            // 注意: 可能为nil或者""
            if let str = source
            {
                // 截取中间字符串
                // 1.获取开始截取的位置位置
                let start = (str as NSString).rangeOfString(">").location + 1
                // 2.获取结束截取的位置
                let end =  (str as NSString).rangeOfString("</").location
                // 3.计算要截取字符串的长度
                let len = end - start
                
                // 4.截取字符串
                let res = (str as NSString).substringWithRange(NSMakeRange(start, len))
                // 5.重新赋值
                source = "来自: \(res)"
            }
        }
    }
    
    /// 会员等级 1~6
    var mbrank: Int = -1
    /// 会员图像
    var memberImage: UIImage? {
        if mbrank > 0 && mbrank < 7 {
            return UIImage(named: "common_icon_membership_level\(mbrank)")
        } else {
            return nil
        }
    }
    
    /// 头像 URL
    var imageURL: NSURL?
    
    /// 属性字典
    static let properties = ["id", "name", "profile_image_url", "verified", "verified_type"]
    init(dict: [String: AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // 打印对象
    override var description: String{
        return "用户模型： \(self.dictionaryWithValuesForKeys(User.properties))"
    }

}
