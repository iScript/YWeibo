//
//  JFOAuthViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

/**
1. 访问oauth登录界面 https://api.weibo.com/oauth2/authorize?client_id=87217000&redirect_uri=https://api.weibo.com/oauth2/default.html
2. 登录成功后返回回调页面  https://api.weibo.com/oauth2/default.html?code=229094d6eef4037e1a8d00037dddca9e
3. 通过code 获取access_token  , post https://api.weibo.com/oauth2/access_token



*/

import UIKit


class OAuthViewController: UIViewController, UIWebViewDelegate {
    
    private let baseUrl = "https://api.weibo.com";
    private let client_id = "872171470";
    private let app_secret = "55ab94a2be7f5794dcb37cf4828636bd";
    private let redirect_uri = "https://api.weibo.com/oauth2/default.html"
    private let grant_type = "authorization_code"
    
    
    // 替换控制器的view
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // 导航标题
        title = "新浪微博授权"
        
        // 加载授权界面
        webView.loadRequest(NSURLRequest(URL: oauthUrl()))
        
        // 设置导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: self, action: #selector(OAuthViewController.cancelOAuth))
        
         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "T", style: UIBarButtonItemStyle.Done, target: self, action: #selector(OAuthViewController.test))
        
    }
    
    
    /**
     获取授权的URL
     */
    func oauthUrl() -> NSURL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        return NSURL(string: urlString)!
    }
    
    
    /**
     取消授权操作，返回主页
     */
    func cancelOAuth() {
        //HUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func test() {
        let href = webView.stringByEvaluatingJavaScriptFromString("window.location.href");
        print(href);
        webView.stringByEvaluatingJavaScriptFromString("document.getElementById('userId').value = 'xiaohao9527@gmail.com';" + "document.getElementById('passwd').value = 'yuan4909951135';")
    }
    
    
  
    
    // MARK: - UIWebViewDelegate
    /**
    开始加载
    */
    func webViewDidStartLoad(webView: UIWebView) {
        //HUD.showStatus("正在加载")
    }
    
    /**
     加载完成
     */
    func webViewDidFinishLoad(webView: UIWebView) {
        //HUD.dismiss()
    }
    
    /**
     栏架webView的请求操作，跟踪重定向URL，是否要加载
     
     */
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 获取完整请求URL字符串
        let urlString = request.URL!.absoluteString
        //print(urlString);
        
        
        // 判断前缀，如果不包含回调前缀则说明不是回调地址，正常加载请求
        if !urlString.hasPrefix(redirect_uri) {
            return true
        }

        // 点击了取消或授权后
        if let query = request.URL?.query {
            
            // 将请求参数转为 NSString
            let tempQuery = query as String
            
            // 点击授权后的固定前缀是 code= (即验证用户名密码后)
            let codeString = "code="
            
            if tempQuery.hasPrefix(codeString) {
                //return true;
                // 参数前缀是 code= 则表示点击了授权，截取code
                let code = tempQuery.substringFromIndex(codeString.endIndex)
                
                self.loadAccessToken(code)
            } else {
                // 点击了取消
                cancelOAuth()
            }
        }
        return true
    }
    
    
    private func loadAccessToken(code: String)
    {
        // 请求参数
        let parameters = [
            "client_id" : client_id,
            "client_secret" : app_secret,
            "grant_type" : grant_type,
            "redirect_uri" : redirect_uri,
            "code" : code
        ]
        print(parameters);
        // 发送POST请求，获取access_token并返回给调用者
        //Http.request(.POST, URLString: "oauth2/access_token", parameters: parameters, finished: finished)
        Http.shareInstance.request(.POST, URLString: baseUrl+"/oauth2/access_token", parameters: parameters) { (result, error) in
            if error != nil || result == nil {
                print(error);
                self.netError("授权失败");return;
            }
            
            //Optional(["access_token": 2.00dL_8xC0mdXBx031d502a0d0u7O4C, "remind_in": 157679999, "uid": 2710578101, "expires_in": 157679999])

            //print(result);
            let account = UserAccount(dict: (result! as [String : AnyObject]))
            account.saveAccount()
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }

    
    /**
     网络数据加载出错时提示
     */
    private func netError(errorMessage: String) {
        //HUD.showError(errorMessage)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.cancelOAuth()
        }
    }
    
    // MARK: - 懒加载
    private lazy var webView: UIWebView = {
        let web = UIWebView()
        web.delegate = self
        return web
    }()
    
}

