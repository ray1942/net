//
//  SysParam.swift
//  SNS
//
//  Created by 千锋 on 16/9/18.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit

class SysParam: NSObject {

    static let SYS_HOST = "10.0.8.8"
    
    static let MAIN_URL = "http://"+SYS_HOST+"/sns/my"
    
    static let Login = MAIN_URL+"/login.php"
    static let Register = MAIN_URL+"/register.php"
    static let Profile = MAIN_URL+"/profile.php"
    static let Logout = MAIN_URL+"/logout.php"
    static let FriendList = MAIN_URL+"/friend.php"
    static let UploadHeadImage = MAIN_URL+"/upload_headimage.php"
    static let UTF8StringEncoding = NSUTF8StringEncoding
}
