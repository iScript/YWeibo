//
//  StatusTableViewCell.swift
//  YWeibo
//
//  Created by 袁克强 on 16/4/20.
//  Copyright © 2016年 袁克强. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {

    var status: Status?{
        didSet{

            nameLabel.text = status!.user!.name
            sourceLabel.text = "来自: 小码哥"
            contentLabel.text = status!.text

             // 设置头像
            if let url = status?.user?.imageURL {
                iconView.sd_setImageWithURL(url)
            }
            // 设置认证图标
            verifiedView.image = status?.user?.verified_img
            // 设置会员图标
            vipView.image = status?.user?.memberImage
            
            sourceLabel.text = status?.user?.source;
            timeLabel.text = status?.created_at
            
            layout.itemSize = CGSize(width: 50, height: 50)
            
            // 刷新表格
            pictureView.reloadData()
        }
    }
    
    
    // 计算行高
    func rowHeight(status: Status) -> CGFloat{
        // 1.设置模型, 以便于调用didSet方法
        self.status = status
        
        // 2.强制更新布局
        layoutIfNeeded()
        
        // 3.返回行高
        return CGRectGetMaxY(footerView.frame)
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 初始化界面
        setupUI()
        // 初始化配图
        preparePictureView()
    }
    
    private func setupUI(){
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(contentLabel)
        addSubview(pictureView)
        
        addSubview(footerView)
        
        iconView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 35,height: 35));
            make.top.left.equalTo(10)
        }
        
        verifiedView.snp_makeConstraints { (make) in
            make.bottom.right.equalTo(iconView).offset(5)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(iconView);
            make.left.equalTo(iconView.snp_right).offset(10)
        }
        
        vipView.snp_makeConstraints { (make) in
            make.top.equalTo(iconView);
            make.left.equalTo(nameLabel.snp_right).offset(10)
        }
        
        timeLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(iconView);
            make.left.equalTo(iconView.snp_right).offset(10)
        }
        
        sourceLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(iconView);
            make.left.equalTo(timeLabel.snp_right).offset(10)
        }
        
        contentLabel.snp_makeConstraints { (make) in
            make.top.equalTo(iconView.snp_bottom).offset(10);
            make.left.equalTo(iconView)
        }
        
        pictureView.snp_makeConstraints { (make) in
            make.left.equalTo(contentLabel);
            make.top.equalTo(contentLabel.snp_bottom).offset(5);
            make.width.equalTo(300)
            make.height.equalTo(100)
        }
        
        
        footerView.snp_makeConstraints { (make) in
            make.left.equalTo(pictureView).offset(-10);
            make.top.equalTo(pictureView.snp_bottom).offset(10);
            make.width.equalTo(SCREEN_WIDTH);
            make.height.equalTo(44)
        }

    }
    
    // MARK: - 懒加载
    /// 头像
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "avatar_default_big"))
    /// 认证图标
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    /// 昵称
    private lazy var nameLabel: UILabel = UILabel(color: UIColor.darkGrayColor(), fontSize: 14)
    
    /// 会员图标
    private lazy var vipView: UIImageView = UIImageView(image:  UIImage(named: "common_icon_membership"))
    /// 时间
    private lazy var timeLabel: UILabel = UILabel(color: UIColor.orangeColor(), fontSize: 10)
    /// 来源
    private lazy var sourceLabel: UILabel = UILabel(color: UIColor.darkGrayColor(), fontSize: 10)
    /// 正文
    private lazy var contentLabel: UILabel = {
        let label = UILabel(color: UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - CGFloat(2 * 10)
        return label
    }()
    
    /// 配图
    private lazy var layout = UICollectionViewFlowLayout()
    private lazy var pictureView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
    
    func preparePictureView(){
        pictureView.registerClass(StatusPictureCell.self, forCellWithReuseIdentifier: "piccc")
        
        // 2.设置数据源代理
        pictureView.dataSource = self

        
        // 3.设置其它属性
        pictureView.backgroundColor = UIColor.lightGrayColor()
        
        // 4.设置间隙
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
    }
    
    private lazy var footerView:StatusFooterView = StatusFooterView();
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

extension StatusTableViewCell: UICollectionViewDataSource
{
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(status?.storedPictureURLs?.count);
        return status?.storedPictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.取出cell
        let itemCell = collectionView.dequeueReusableCellWithReuseIdentifier("piccc", forIndexPath: indexPath) as! StatusPictureCell
        // 2.设置图片
        itemCell.imageURL = status?.storedPictureURLs![indexPath.item]
        // 3.返回cell
        return itemCell
    }
}
private class StatusPictureCell: UICollectionViewCell {
    var imageURL: NSURL?{
        didSet{
            iconView.sd_setImageWithURL(imageURL!)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.greenColor()
        
        addSubview(iconView)
        iconView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var iconView = UIImageView()
}


class StatusFooterView:UIView{
    override init(frame: CGRect) {
        super.init(frame: frame);
        setupUI();
    }
    
    func setupUI(){
        addSubview(retweetBtn);
        addSubview(likeBtn);
        addSubview(commentBtn);
        
        backgroundColor = UIColor.greenColor()
        
        
    }
    
    private lazy var retweetBtn:UIButton = {
        let btn = UIButton();
        btn.setImage(UIImage(named:"timeline_icon_retweet"), forState: .Normal)
        btn.setTitle("转发", forState: UIControlState.Normal)
        return btn;
    }();
    
    private lazy var likeBtn:UIButton = {
        let btn = UIButton();
        btn.setImage(UIImage(named:"timeline_icon_unlike"), forState: .Normal)
        btn.setTitle("赞", forState: UIControlState.Normal)
        return btn;
    }();
    
    private lazy var commentBtn:UIButton = {
        let btn = UIButton();
        btn.setImage(UIImage(named:"timeline_icon_comment"), forState: .Normal)
        btn.setTitle("评论", forState: UIControlState.Normal)
        return btn;
    }();
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
}
