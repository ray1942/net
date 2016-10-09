//
//  LoginViewController.swift
//  SNS
//
//  Created by 千锋 on 16/9/13.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit
//取view得tag会递归调用

//登录注册界面
class LoginViewController: UIViewController {

//    用户名
    var nameTextField:UITextField?
//     密码
    var pwdTextField:UITextField?
//    邮箱
    var emailTextField:UITextField?
    
    var registerBtn:UIButton?
    
    var loginBtn:UIButton?
    
    var activityView:UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
//        1.用户名
        let nameLabel = MyUtil.createLabel(CGRectMake(40, 100, 80, 40), text: "用户名")
        nameTextField = MyUtil.createTextField(CGRectMake(140, 100, 250, 40), placeHolder: "请输入用户名", isPwd: false)
        self.view.addSubview(nameLabel)
        self.view.addSubview(nameTextField!)
//        2.密码
        let pwdLabel = MyUtil.createLabel(CGRectMake(40, 160, 80, 40), text: "密码")
        pwdTextField = MyUtil.createTextField(CGRectMake(140, 160, 250, 40), placeHolder: "请输入密码", isPwd: true)
        self.view.addSubview(pwdLabel)
        self.view.addSubview(pwdTextField!)
//        3.邮箱
        let emailLabel = MyUtil.createLabel(CGRectMake(40, 220, 80, 40), text: "邮箱")
        emailTextField = MyUtil.createTextField(CGRectMake(140, 220, 250, 40), placeHolder: "请输入邮箱", isPwd: false)
        self.view.addSubview(emailLabel)
        self.view.addSubview(emailTextField!)
//        4.登录按钮
        loginBtn = MyUtil.createButton(CGRectMake(240, 300, 60, 40), title: "登录", target: self, action: "loginAction")
//        5.注册按钮
        registerBtn = MyUtil.createButton(CGRectMake(80, 300, 60, 40), title: "注册", target: self, action: "registerAction")
        self.view.addSubview(loginBtn!)
        self.view.addSubview(registerBtn!)
        
        nameTextField!.text = "ray_1942"
        pwdTextField!.text = "woshihaohaizi"
        
        
//        小菊花
        activityView = MyUtil.creatActivityView(CGRectMake((414-20)/2, (736-20)/2, 40, 40), viewStyle: .Gray, superView: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginAction(){
//         http://10.0.8.8/sns/my/login.php?username=test&password=123456
        if nameTextField?.text == "" || pwdTextField?.text == "" {
            MyUtil.showAlert(onViewController: self,msg: "用户名密码不能为空",nil)
            return
        }
        
        let name = self.nameTextField?.text?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let pwd = self.pwdTextField?.text?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = String(format: SysParam.Login+"?username=%@&password=%@", name!,pwd!)
        let download = SNSDownloader()
        download.delegate = self
        download.type = .Login
        download.downloadWithUrlString(url)
        registerBtn?.enabled = false
        loginBtn?.enabled = false
        activityView!.startAnimating()
    }
    func registerAction(){
        
        
//        http://10.0.8.8/sns/my/register.php?username=haha&password=123456&email=qq@qq.com
        
//        将中文字符进行编码
//        let name = (nameTextField?.text)?.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)弃用
        let name = (nameTextField?.text)?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let pwd = (pwdTextField?.text)?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let email = (emailTextField?.text)?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        if nameTextField?.text != "" && pwdTextField?.text != "" && emailTextField?.text != ""{
//            格式控制符 可以在字符串中加变量
//            基本类型%d、%zd Int %ld NSInteger %f Float %lf Double %@ 对象(其他对象类型)
            let url = String(format: SysParam.Register+"?username=%@&password=%@&email=%@",name!,pwd!,email!)
            let download = SNSDownloader()
            download.delegate = self
            download.type = .Register
            download.downloadWithUrlString(url)
            registerBtn?.enabled = false
            loginBtn?.enabled = false
            activityView!.startAnimating()
            
        }else{
            
//            提示
            MyUtil.showAlert(onViewController: self,msg: "用户名/密码/邮箱不能为空", nil)
            
        }
    }

}
extension LoginViewController:SNSDownloaderDelegate{
    
    func downloader(download: SNSDownloader, didFailWithError error: NSError) {
        
        if download.type == .Register{
            MyUtil.showAlert(onViewController: self,msg: "注册失败",nil)
        }else{
            MyUtil.showAlert(onViewController: self,msg: "登录失败",nil)
        }
    }
    
    
    func downloader(download: SNSDownloader, didFinishWithData data: NSData) {
        
        if download.type == .Register{
            let jsonData = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            if jsonData.isKindOfClass(NSDictionary){
                let result = jsonData as! Dictionary<String,AnyObject>
                let registerInfo = result["message"] as! String
                let code = result["code"] as! String
                if code == "registered"{
                    MyUtil.showAlert(onViewController: self,msg: registerInfo,nil)
                }else{
                    MyUtil.showAlert(onViewController: self,msg: registerInfo,nil)
                }
                registerBtn?.enabled = true
                loginBtn?.enabled = true
                activityView!.stopAnimating()
            }
        }else if download.type == .Login{
            //登录
            let jsonData = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            
            if jsonData.isKindOfClass(NSDictionary) {
                let dic = jsonData as! Dictionary<String,AnyObject>
                let code = dic["code"] as! String
                let message = dic["message"] as! String
                if code == "login_success" {
                    MyUtil.showAlert(onViewController: self,msg: 
                        message){
                        [weak self] in
                        let rvc = RootViewController()
                        self!.navigationController?.pushViewController(rvc, animated: true)
                    }
                    
//                    存储token值 
                    let token = dic["m_auth"] as! String
                    let uid = dic["uid"] as! String
                    let ud = NSUserDefaults.standardUserDefaults()
                    ud.setObject(token, forKey: "m_auth")
                    ud.setObject(uid, forKey: "uid")
                    ud.synchronize()//将内存中的信息同步文件
                    registerBtn?.enabled = true
                    loginBtn?.enabled = true
                    activityView!.stopAnimating()
                }else{
                    MyUtil.showAlert(onViewController: self,msg: message,nil)
                    registerBtn?.enabled = true
                    loginBtn?.enabled = true
                    activityView!.stopAnimating()
                }
            }
            
        }
    }
    
}
