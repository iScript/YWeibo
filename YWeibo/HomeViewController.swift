//
//  HomeViewController.swift
//  YWeibo
//
//  Created by 袁克强 on 16/4/18.
//  Copyright © 2016年 袁克强. All rights reserved.
//

import UIKit

let HomeCellReuseIdentifier = "HomeCellReuseIdentifier"

class HomeViewController: UITableViewController {
    
    
    
    /// 微博数据数组
    var statuses: [Status]? {
        didSet{
            // 刷新数据
            tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        
        print(UserAccount.loadAccount())
        
        // 4.注册cell
        tableView.registerClass(StatusTableViewCell.self, forCellReuseIdentifier: HomeCellReuseIdentifier)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // 5.加载微博数据
        loadData()
    }
    
    // 缓存行高
    private var rowHeightCache = [Int: CGFloat]()
    override func didReceiveMemoryWarning() {
        // 处理内存警告
        print("内存警告？？");
        rowHeightCache.removeAll()
    }
    
    /**
     加载微博数据
     */
    private func loadData(){
        Status.loadStatuses { (statuses, error) -> () in
            
            self.statuses = statuses
        }
    }
    

    private func setupNav()
    {
        // 1.初始化左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: #selector(HomeViewController.leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: #selector(HomeViewController.rightItemClick))
        

        let titleBtn = TitleButton()
        titleBtn.setTitle("极客江南 ", forState: UIControlState.Normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
    }

    func leftItemClick(){
        let nv = UINavigationController(rootViewController: OAuthViewController())
        self.presentViewController(nv, animated: true, completion: nil);return;
        

    }
    
    func rightItemClick(){
        //let aa = UserAccount.loadAccount();
        //print(aa );
    }

    func titleBtnClick(){
    
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



extension HomeViewController
{

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // 1.获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(HomeCellReuseIdentifier, forIndexPath: indexPath) as! StatusTableViewCell
        // 2.设置数据
        let status = statuses![indexPath.row]
        cell.status = status
        
        // 3.返回cell
        return cell
    }
    
    /**
     返回行高
     */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // 1.获取对应行模型
        let status = statuses![indexPath.row]
        
        // 0.从缓存中取
        if rowHeightCache[status.id] != nil{
            return rowHeightCache[status.id]!
        }
        
        // 2.获取对应行cell
        let cell = tableView.dequeueReusableCellWithIdentifier(HomeCellReuseIdentifier) as! StatusTableViewCell
        
        // 3.获取行高
        let height = cell.rowHeight(status)
        rowHeightCache[status.id] = height
        return height
    }

    
}
