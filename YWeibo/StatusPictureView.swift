//
//  StatusPictureView.swift
//  YWeibo
//
//  Created by 袁克强 on 16/4/21.
//  Copyright © 2016年 袁克强. All rights reserved.
//

import UIKit

class StatusPictureView: UICollectionView {
    
    
    var status:Status?{
        didSet{
            reloadData()
        }
    }
    
    private var layout = UICollectionViewFlowLayout()
    //private lazy var pictureView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
    
    
    init(){
        super.init(frame: CGRectZero, collectionViewLayout: layout)
        
        registerClass(StatusPictureCell.self, forCellWithReuseIdentifier: "piccc")
        
        // 2.设置数据源代理
        dataSource = self
        
        
        // 3.设置其它属性
        backgroundColor = UIColor.lightGrayColor()
        
        // 4.设置间隙
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 50, height: 50)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}


extension  StatusPictureView: UICollectionViewDataSource
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
