//
//  HeadImageViewController.swift
//  SNS
//
//  Created by 千锋 on 16/9/19.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HeadImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        
        let uid = NSUserDefaults.standardUserDefaults().objectForKey("uid") as! String
        let urlString = String(format: "http://10.0.8.8/sns/my/headimage.php?size=big&uid=%@", uid)
        
        Alamofire.request(.GET, urlString).responseData { (response) -> Void in
            switch response.result {
            case .Failure(let error):
                print(error)
            case .Success:
                let data = response.data
//                显示图片
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let image = UIImage(data: data!)
                    let imageView = UIImageView(frame: CGRectMake(0, 64, (image?.size.width)!, (image?.size.height)!))
                    imageView.image = image
                    self.view.addSubview(imageView)
                })
            }
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
