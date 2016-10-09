//
//  MyUtil.swift
//  SNS
//
//  Created by 千锋 on 16/9/13.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit

/*

创建基本ui对象 等的工具类

*/
class MyUtil: NSObject {

    
    
//    创建标签
    class func createLabel(frame:CGRect,text:String?)->UILabel{
        let label = UILabel(frame: frame)
        label.text = text
        return label
    }
//    创建按钮
    class func createButton(frame:CGRect,title:String?,target:AnyObject?,action:Selector?)->UIButton{
        let button = UIButton(type: .System)
        button.frame = frame
        if let btnTitle = title{
            button.setTitle(btnTitle, forState: .Normal)
        }
        if let tmpTarget = target{
            button.addTarget(tmpTarget, action: action!, forControlEvents: .TouchUpInside)
        }
        return button
    }
    
    
//    创建输入框
    /* 
     *@param isPwd:是否是安全输入
     */
    class func createTextField(frame:CGRect,placeHolder:String?,isPwd:Bool)->UITextField{
        let textField = UITextField(frame: frame)
        if let tmpPlaceHolder = placeHolder{
            textField.placeholder = tmpPlaceHolder
        }
        textField.autocorrectionType = .No
        textField.autocapitalizationType = .None
        textField.borderStyle = .RoundedRect
        textField.secureTextEntry = isPwd
        return textField
    }
    
    //    显示提示信息
    class func showAlert(onViewController vCtrl:UIViewController, msg:String,_ confirmClosure:(Void->Void)?){
        
        //        UIAlertV
        let alertController = UIAlertController(title: "提示", message: msg, preferredStyle: .Alert)
        //        添加按钮
        let action = UIAlertAction(title: "确定", style: .Default) { (action) -> Void in
            if let myClosure = confirmClosure{
                myClosure()
            }
        }
        alertController.addAction(action)
        //        显示
//        将UI显示到主线程上
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            vCtrl.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    class func creatActivityView(frame:CGRect,viewStyle:UIActivityIndicatorViewStyle?,superView:UIView)->UIActivityIndicatorView{
//        小菊花
        let activityView = UIActivityIndicatorView()
        activityView.frame = CGRectMake((414-20)/2, (736-20)/2, 40, 40)
        if let tmpStyle = viewStyle{
            activityView.activityIndicatorViewStyle = tmpStyle
        }
        superView.addSubview(activityView)
        return activityView
    }
    
}
