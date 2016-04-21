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

            topView.status = status
            contentLabel.text = status!.text
            pictureView.status = status
            
  
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

    }
    
    private func setupUI(){
        addSubview(topView)
        addSubview(contentLabel)
        addSubview(pictureView)
        addSubview(footerView)
        
        topView.snp_makeConstraints { (make) in
            make.width.equalTo(self);
            make.height.equalTo(55);
            make.top.equalTo(0)
            make.left.equalTo(0)
        }
                
        contentLabel.snp_makeConstraints { (make) in
            make.top.equalTo(topView.snp_bottom).offset(10);
            make.left.equalTo(topView).offset(10)
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
    
    
    /// 顶部视图
    lazy var topView: StatusTopView = StatusTopView()
    
    /// 正文
    private lazy var contentLabel: UILabel = {
        let label = UILabel(color: UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - CGFloat(2 * 10)
        return label
    }()
    
    /// 配图
    private lazy var pictureView: StatusPictureView = StatusPictureView();
    
    private lazy var footerView:StatusBottomView = StatusBottomView();
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}




