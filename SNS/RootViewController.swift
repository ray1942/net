//
//  RootViewController.swift
//  SNS
//
//  Created by 千锋 on 16/9/13.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit
import Alamofire
//主页
class RootViewController: UIViewController {

//    数据源数组
    var dataArray = ["个人资料","注销","好友列表","头像上传","获取头像","公开用户列表","相册列表"]
    var tbView:UITableView?
    
    func createTableView(){
        self.automaticallyAdjustsScrollViewInsets = false
        tbView = UITableView(frame: CGRectMake(0, 64, 414, 672), style: .Plain)
        tbView?.delegate = self
        tbView?.dataSource = self
        self.view.addSubview(tbView!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "主页"
        
        self.view.backgroundColor = UIColor.whiteColor()
        createTableView()
    }
    
    
//注销
    func logout(){
        
        //            注销
        //            http://10.0.8.8/sns/my/logout.php?uid=417
        let downloader = SNSSessionDownloader()
        downloader.delegate = self
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("uid") as! String
        downloader.postWithUrl("http://10.0.8.8/sns/my/logout.php", parameter: [ "uid" : uid ])
        
    }
//MARK: 头像上传
    func uploadHeadImage(){
//        参数1 请求方式
//        参数2 网址
//        参数3 文件数据
//        参数4 请求返回时调用的闭包
        Alamofire.upload(.POST, SysParam.UploadHeadImage, multipartFormData: { (formData) -> Void in
            
//            1.用户token值
            let ud = NSUserDefaults.standardUserDefaults()
            let uid = ud.objectForKey("uid") as! String
//            转二进制
            let uidData = uid.dataUsingEncoding(SysParam.UTF8StringEncoding)
            formData.appendBodyPart(data: uidData!, name: "uid")
//            图片
//            参数1 图片数据
//            参数2 key值
//            参数3 类型
            let path = NSBundle.mainBundle().pathForResource("classic_smile_win", ofType: "png")
//            可以将名字和格式写一起contentview_hd_loading.gif
            let data = NSData(contentsOfFile: path!)
            formData.appendBodyPart(data: data!, name: "headimage",fileName: "newFile", mimeType: "image/png")
            
            }) { (dataEncoding) -> Void in
                switch dataEncoding {
                case .Failure(let error):
                    MyUtil.showAlert(onViewController: self, msg: "上传失败\(error)", nil)
                case .Success(let request,_,_):
                    request.responseJSON(completionHandler: { (response) -> Void in
                        switch response.result {
                        case .Failure(let error):
                            MyUtil.showAlert(onViewController: self, msg: "上传失败\(error)", nil)
                        case .Success(let jsonData):
                            
                            let dict = jsonData as! Dictionary<String,AnyObject>
                            let code = dict["code"] as! String
                            let msg = dict["message"] as! String
                            if code == "upload_file_ok" {
                                MyUtil.showAlert(onViewController: self, msg: "上传成功\(jsonData)", nil)
                            }else{
                                MyUtil.showAlert(onViewController: self, msg: "上传成功\(jsonData)", nil)
                            }
                        }
                    })
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RootViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("item")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "item")
        }
        cell?.textLabel?.text = dataArray[indexPath.row]
        return cell!
    }
    
//MARK: 添加Cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let pvc = ProfileViewController()
            self.navigationController?.pushViewController(pvc, animated: true)
//            self.navigationController?.showViewController(vc: UIViewController, sender: AnyObject?) 和上面等价
        }else if indexPath.row == 1{
            logout()
        }else if indexPath.row == 2{
            let flvc = FriendListViewController()
            self.navigationController?.pushViewController(flvc, animated: true)
        }else if indexPath.row == 3{
            uploadHeadImage()
        }else if indexPath.row == 4{
//            let 获取头像
            let hvc = HeadImageViewController()
            self.navigationController?.pushViewController(hvc, animated: true)
        }else if indexPath.row == 5{
            let uvc = UserListViewController()
            self.navigationController?.pushViewController(uvc, animated: true)
        }else if indexPath.row == 6 {
            let avc = AlbumListViewController()
            self.navigationController?.pushViewController(avc, animated: true)
        }
    }
}

//MARK: SNSSessionDownloader代理注销
extension RootViewController:SNSSessionDownloaderDelegate{
    func sessionDownloader(downloader: SNSSessionDownloader, didFailWithError error: NSError) {
        MyUtil.showAlert(onViewController: self, msg: "注销失败", nil)
    }
    func sessionDownloader(downloader: SNSSessionDownloader, didFinishWithData data: NSData) {
        let jsonData = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        if jsonData.isKindOfClass(NSDictionary){
            let dic = jsonData as! Dictionary<String,AnyObject>
            let code = dic["code"] as! String
            let msg = dic["message"] as! String
            print(code,msg)
            if code == "security_exit" {
                MyUtil.showAlert(onViewController: self, msg: msg, {
                    [weak self] in
                    self!.navigationController?.popViewControllerAnimated(true)
//                    清楚Token值
                    let ud = NSUserDefaults.standardUserDefaults()
                    ud.removeObjectForKey("m_auth")
                    ud.removeObjectForKey("uid")
                    ud.synchronize()
                })
            }else{
                MyUtil.showAlert(onViewController: self, msg: msg, nil)
            }
        }
    }
}