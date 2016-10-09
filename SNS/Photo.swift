//
//  Photo.swift
//  SNS
//
//  Created by 千锋 on 16/9/23.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit
import SwiftyJSON

class Photo: NSObject {

    var albumid:String?
    var pic:String?
    var pic_origin:String?
    var picid:String?
    var title:String?
    var uid:String?
    var width:String?
    var height:String?
    
//    
    class func parseModel(dic:NSDictionary)->[Photo]{
        let json = JSON(dic)
        var array = [Photo]()

        for (_,subjson) in json["photos"]{
            let model = Photo()
            model.albumid = subjson["albumid"].string
            model.pic = subjson["pic"].string
            model.pic_origin = subjson["pic_origin"].string
            model.picid = subjson["picid"].string
            model.title = subjson["title"].string
            model.uid = subjson["uid"].string
            model.width = subjson["width"].string
            model.height = subjson["height"].string
            array.append(model)
        }
        return array
    }
    
}
