//
//  Status.swift
//  YWeibo
//
//  Created by 袁克强 on 16/4/20.
//  Copyright © 2016年 袁克强. All rights reserved.
//

import UIKit
private let WB_HOME_TIMELINE = "/2/statuses/home_timeline.json";
class Status: NSObject {
    /// 微博创建时间
    var created_at: String?
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
    /// 用户模型
    var user: User?
    
    /// 配图数组
    var pic_urls: [[String: AnyObject]]?{
        didSet{
            // 1.判断数组中是否有数据 nil
            if pic_urls?.count == 0{
                return
            }
            // 2.实例化数组
            storedPictureURLs = [NSURL]()
            // 3.遍历字典生成 url 的数组
            for dict in pic_urls!{
                if let urlString = dict["thumbnail_pic"] as? String {
                    // 生成缩略图的 URL
                    storedPictureURLs?.append(NSURL(string: urlString)!)
                }
            }
        }
    }
    /// `保存`配图的 URL 的数组
    var storedPictureURLs: [NSURL]?
    
    
    // 定义类属性数组
    static let properties = ["created_at", "id", "text", "source", "pic_urls","user"]
    
    // 自定义构造函数
    init(dict: [String: AnyObject]){
        super.init()
        // 会调用 setValue forKey 给每一个属性赋值
        setValuesForKeysWithDictionary(dict)
    }
    
    class func loadStatuses(finished: (statuses: [Status]?, error: NSError?)->()){
        let params = ["access_token": UserAccount.loadAccount()!.access_token!]
        Http.shareInstance.request(.GET, URLString: HOST+WB_HOME_TIMELINE, parameters: params) { (result, error) in
            
            // 加载数据出错
            if error != nil || result == nil {
                finished(statuses: nil, error: error)
                return
            }

            // 字典转换模型
            if let statuses = result?["statuses"] as? [[String: AnyObject]] {
                let models = Status.toModel(statuses)
                finished(statuses: models, error: nil)
            }

        }
    }
    
    private class func cacheWebImage(list: [Status], finished: (statuses: [Status]?, error: NSError?)->())
    {
        // 创建调度组
        let group = dispatch_group_create()
        
        for status in list{
            // guard语句的作用到底是什么呢？顾名思义，就是守护。guard语句判断其后的表达式布尔值为false时，才会执行之后代码块里的代码，如果为true，则跳过整个guard语句
            if status.storedPictureURLs == nil
            {
                continue
            }
            
            // 下载图片
            for url in status.storedPictureURLs!
            {
                // 加入调度组
                dispatch_group_enter(group)
                
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) -> Void in
                    // 离开调度组
                    dispatch_group_leave(group)
                })
            }
            
            // 监听所有缓存操作的通知
            dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
                // 获得完整的微博数组，可以回调
                // 回调通知调用者
                finished(statuses: list, error: nil)
            }
        }
    }
    
    
    /// 使用传入数组完成字典转模型
    private class func toModel(array: [[String:AnyObject]]) -> [Status]{
        var models = [Status]()
        for dict in array{
            models.append(Status(dict: dict))
        }
        return models
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        // 判断 key 是否是 user，如果是 user 单独处理
        if key == "user"{
            // 判断 value 是否是一个有效的字典
            if let dict = value as? [String: AnyObject]{
                // 创建用户数据
                user = User(dict: dict)
            }
            return
        }
        // 如果不是调用父类方法进行默认处理
        super.setValue(value, forKey: key)
    }
    
    // 如果没有对应的key会调用这个方法
    override func setValue(value: AnyObject?, forUndefinedKey key: String){}
    // 打印对象
    override var description: String{
        return "微博模型 ： \(self.dictionaryWithValuesForKeys(Status.properties))"
    }
}
