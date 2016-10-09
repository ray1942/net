//
//  Album.swift
//  SNS
//
//  Created by 千锋 on 16/9/23.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit
import SwiftyJSON

class Album: NSObject {

    var albumname:String?
    var id:String?
    var pics:String?
    
    class func parseModel(data:NSDictionary)->[Album]{
        let json = JSON(data)
//        遍历数组
        var array = [Album]()
        for (_,subjson) in json["albums"]{
            let model = Album()
            model.albumname = subjson["albumname"].string
            model.id = subjson["id"].string
            model.pics = subjson["pics"].string
            array.append(model)
        }
        print(data)
        return array
    }
    
}
