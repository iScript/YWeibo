//
//  UserAccount.swift
//  YWeibo
//
//  Created by 袁克强 on 16/4/19.
//  Copyright © 2016年 袁克强. All rights reserved.
//

//import Foundation

/***
 Optional(["access_token": 2.00dL_8xC0mdXBx031d502a0d0u7O4C, "remind_in": 157679999, "uid": 2710578101, "expires_in": 157679999])
 **/


import UIKit


class UserAccount: NSObject , NSCoding{
    
    var access_token: String?
    
    /// access_token的生命周期，单位是秒数。
    var expires_in: NSNumber?{
        didSet{
            expires_Date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
            print(expires_Date)
        }
    }
    
    /// 保存用户过期时间
    var expires_Date: NSDate?
    /// 当前授权用户的UID。
    var uid:String?
    
    
    init(dict: [String: AnyObject])
    {
        super.init()
        /*
         access_token = dict["access_token"] as? String
         // 注意: 如果直接赋值, 不会调用didSet
         expires_in = dict["expires_in"] as? NSNumber
         uid = dict["uid"] as? String
         */
        
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print(key)
    }
    
    
    static var account: UserAccount?
    class func loadAccount() -> UserAccount? {
        
        // 1.判断是否已经加载过
        if account != nil
        {
            return account
        }
        account =  NSKeyedUnarchiver.unarchiveObjectWithFile(USER_DATA_PATH) as? UserAccount

        if account?.expires_Date?.compare(NSDate()) == NSComparisonResult.OrderedAscending
        {
            return nil
        }
        
        return account
    }
    
    class func isLogin() -> Bool{
        return UserAccount.loadAccount() != nil
    }
    
    
    func saveAccount()
    {
        NSKeyedArchiver.archiveRootObject(self, toFile: USER_DATA_PATH)
    }
    
    override var description: String{
        // 1.定义属性数组
        let properties = ["access_token", "expires_in", "uid"]
        // 2.根据属性数组, 将属性转换为字典
        let dict =  self.dictionaryWithValuesForKeys(properties)
        // 3.将字典转换为字符串
        return "\(dict)"
    }
    
    
    
    
    // MARK: - NSCoding
    // 将对象写入到文件中
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
    }
    // 从文件中读取对象
    required init?(coder aDecoder: NSCoder)
    {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
    }
}