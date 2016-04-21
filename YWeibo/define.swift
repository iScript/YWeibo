//
//  define.swift
//  YWeibo
//
//  Created by 袁克强 on 16/4/18.
//  Copyright © 2016年 袁克强. All rights reserved.
//
import UIKit

let DEBUG = true;

let APP_NAME = "xxx";
let APP_DESCRIPTION = "xxx"

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width;
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height;


//let HOST = "http://tqq.test.com";
//let HOST = "http://api.wtweika.com";

let QINIU_HOST = "http://7xr0sv.com1.z0.glb.clouddn.com";

let UM_TRACK_APPKEY = "570b65fde0f55a297b000faa";


let HOST = "https://api.weibo.com";

// 保存用户信息的路径
let USER_DATA_PATH = "\(NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!)/userAccount.plist"