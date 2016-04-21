//
//  StatusBottomView.swift
//  YWeibo
//
//  Created by 袁克强 on 16/4/21.
//  Copyright © 2016年 袁克强. All rights reserved.
//

import UIKit

class StatusBottomView: UIView {

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
