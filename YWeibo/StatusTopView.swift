//
//  StatusTopView.swift
//  YWeibo
//
//  Created by 袁克强 on 16/4/21.
//  Copyright © 2016年 袁克强. All rights reserved.
//

import UIKit

class StatusTopView: UIView {

    var status:Status?{
        didSet{
            nameLabel.text = status!.user!.name
            sourceLabel.text = status?.source
            
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
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setupUI();
    }
    
    func setupUI(){
        addSubview(headerView)
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        headerView.snp_makeConstraints { (make) in
            make.top.left.equalTo(0);
            make.height.equalTo(10);
            make.width.equalTo(self)
        }
        iconView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 35,height: 35));
            make.top.equalTo(20)
            make.left.equalTo(10)
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

        
    }
    
    // MARK: - 懒加载
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGrayColor()
        return view
    }()
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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
