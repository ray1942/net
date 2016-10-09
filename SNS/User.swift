//
//  User.swift
//  SNS
//
//  Created by 千锋 on 16/9/19.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {

    var credit:String?
    var experience:String?
    var friendnum:String?
    
    var groupid:String?
    var headimage:String?
    var lastactivity:String?
    var realname:String?
    
    var uid:String?
    var username:String?
    var viewnum:String?
    
    class func parseModel(data:NSData)->[User]{
        
        var array = [User]()
        let jsonData = JSON(data:data)
        for (_,subjson) in jsonData["users"]{
            let user = User()
            user.credit = subjson["credit"].string
            user.experience = subjson["experience"].string
            user.friendnum = subjson["friendnum"].string
            user.groupid = subjson["groupid"].string
            user.headimage = subjson["headimage"].string
            user.lastactivity = subjson["lastactivity"].string
            user.realname = subjson["realname"].string
            user.uid = subjson["uid"].string
            user.username = subjson["username"].string
            user.viewnum = subjson["viewnum"].string
            array.append(user)
        }
        return array
    }
    
}
