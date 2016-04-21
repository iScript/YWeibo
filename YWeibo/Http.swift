//
//  Http.swift
//  YWeibo
//
//  Created by 袁克强 on 16/4/18.
//  Copyright © 2016年 袁克强. All rights reserved.
//

import UIKit
//import AFNetworking

/// 网络请求方式
enum HttpMethod: String {
    case GET
    case POST
}

/// 网络回调闭包别名
typealias NetworkFinishedCallBack = (result: [String : AnyObject]?, error: NSError?) -> ()

// MARK: - 网络工具类
class Http: NSObject {
    
    // MARK: - 属性
    /// 创建网络请求单例
    static let shareInstance = Http()
    
    /// AFN网络请求对象
    private var afnManager: AFHTTPSessionManager
    
    /**
     重写初始化方法
     */
    override init() {
        afnManager = AFHTTPSessionManager();
        
        //微博返回的是text/plain ？？？？
        afnManager.responseSerializer.acceptableContentTypes?.insert("text/plain")
    }
    
    func request(requestMethod: HttpMethod, URLString: String, parameters: [String : AnyObject]?, finished: NetworkFinishedCallBack) {
        
        //如果登录过，默认都加上token
        var param = (parameters != nil) ? parameters : [String : AnyObject]() ;

        
        // 根据请求方式，发送请求
        switch requestMethod {
            
        // GET方式
        case .GET:
            self.afnManager.GET(URLString, parameters: param, success: { (task, result) -> Void in
                let r = result as? [String : AnyObject];

                finished(result: r , error: nil)
                }, failure: { (task, error) -> Void in

                    finished(result: nil, error: error)
            })
            
            
            
            
        // POST方式
        case .POST:
            self.afnManager.POST(URLString, parameters: param, success: { (task, result) -> Void in
                let r = result as? [String : AnyObject];
                
                finished(result: r, error: nil)
                }, failure: { (task, error) -> Void in
                    finished(result: nil, error: error)
            })
            
        }
        
    }
    
}





