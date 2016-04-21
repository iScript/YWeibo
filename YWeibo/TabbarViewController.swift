//
//  TabbarViewController.swift
//  YWeibo
//
//  Created by 袁克强 on 16/4/18.
//  Copyright © 2016年 袁克强. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewControllers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 添加加号按钮
        setupComposeBtn()
    }
    
    /**
     监听加号按钮点击
     按钮点击事件的调用是由 运行循环 监听并且以消息机制传递的，因此，按钮监听函数不能设置为 private
     */
    func composeBtnClick(){
        print(#function)
    }
    
    // MARK: - 内部控制方法
    private func setupComposeBtn()
    {
        // 1.添加加号按钮
        tabBar.addSubview(composeBtn)
        
        // 2.调整加号按钮的位置
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat(viewControllers!.count)
        let rect  = CGRect(x: 0, y: 0, width: width, height: 49)
        // 第一个参数:是frame的大小
        // 第二个参数:是x方向偏移的大小
        // 第三个参数: 是y方向偏移的大小
        composeBtn.frame = CGRectOffset(rect, 2 * width, 0)
    }
    
    /**
     添加所有子控制器
     */
    private func addChildViewControllers() {
        // 1.获取json文件的路径
        let path = NSBundle.mainBundle().pathForResource("MainVC.json", ofType: nil)

        if let jsonPath = path{
            let jsonData = NSData(contentsOfFile: jsonPath)
            
            do{

                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)

                for dict in dictArr as! [[String: String]]
                {
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                }
                
            }catch
            {
                // 发生异常之后会执行的代码
                print(error)
                
                // 从本地创建控制器
                addChildViewController("HomeViewController", title: "首页", imageName: "tabbar_home")
                addChildViewController("MessageViewController", title: "消息", imageName: "tabbar_message_center")
                
                // 再添加一个占位控制器
                addChildViewController("NullViewController", title: "", imageName: "")
                addChildViewController("DiscoverViewController", title: "广场", imageName: "tabbar_discover")
                addChildViewController("ProfileViewController", title: "我", imageName: "tabbar_profile")
            }
        }
        
    }
    
    /**
     初始化子控制器
     
     :param: childController 需要初始化的子控制器
     :param: title           子控制器的标题
     :param: imageName       子控制器的图片
     */
    private func addChildViewController(childControllerName: String, title:String, imageName:String) {
        // 动态获取命名空间
        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String

        let cls:AnyClass? = NSClassFromString(ns + "." + childControllerName)
        

        let vcCls = cls as! UIViewController.Type
        // 0.2.2通过class创建对象
        let vc = vcCls.init()
        
        // 1设置首页对应的数据
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        vc.title = title
        
        // 2.给首页包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        
        // 3.将导航控制器添加到当前控制器上
        addChildViewController(nav)
    }
    
    
    // MARK: - 懒加载
    private lazy var composeBtn:UIButton = {
        let btn = UIButton()
        
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        

        btn.addTarget(self, action: #selector(TabbarViewController.composeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
}
