//
//  ComposeViewController.swift
//  YWeibo
//
//  Created by 袁克强 on 16/4/21.
//  Copyright © 2016年 袁克强. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()

        setupInpuView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 主动召唤键盘
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 主动隐藏键盘
        textView.resignFirstResponder()
    }
    
    
    private func setupInpuView()
    {
        // 1.添加子控件
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        
        // 2.布局子控件
        textView.snp_makeConstraints { (make) in
            make.left.top.equalTo(5);
            make.width.equalTo(SCREEN_WIDTH-10);
            make.height.equalTo(SCREEN_HEIGHT-10)
        }
        
        placeholderLabel.snp_makeConstraints { (make) in
            make.left.top.equalTo(textView).offset(5)
        }
        
        //placeholderLabel.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: textView, size: nil, offset: CGPoint(x: 5, y: 8))
    }
    
    
    /**
     初始化导航条
     */
    private func setupNav()
    {
        // 1.添加左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NSStream.close))
        
        // 2.添加右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ComposeViewController.sendStatus))
        navigationItem.rightBarButtonItem?.enabled = false
        
        self.title = "发微博";
    }
    
    
    /**
     关闭控制器
     */
    func close()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendStatus()
    {
        let path = "/2/statuses/update.json"
        let params = ["access_token":UserAccount.loadAccount()?.access_token! , "status": textView.text]
        Http.shareInstance.request(.POST, URLString: HOST+path, parameters: params) { (result, error) in
            if(error != nil || result == nil ){
                SVProgressHUD.showErrorWithStatus("发送失败");return;
            }
            
            SVProgressHUD.showSuccessWithStatus("发送成功")
            self.close();
        }
        
//        NetworkTools.shareNetworkTools().POST(path, parameters: params, success: { (_, JSON) -> Void in
//            //            print(JSON)
//            
//            // 1.提示用户发送成功
//            SVProgressHUD.showSuccessWithStatus("发送成功", maskType: SVProgressHUDMaskType.Black)
//            // 2.关闭发送界面
//            self.close()
//        }) { (_, error) -> Void in
//            print(error)
//            // 3.提示用户发送失败
//            SVProgressHUD.showErrorWithStatus("发送失败", maskType: SVProgressHUDMaskType.Black)
//        }

    }
    
    // MARK: - 懒加载
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        
        return tv
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.darkGrayColor()
        label.text = "分享新鲜事..."
        return label
    }()
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ComposeViewController: UITextViewDelegate
{
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
}

