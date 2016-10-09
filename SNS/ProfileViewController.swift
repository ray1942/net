//
//  ProfileViewController.swift
//  SNS
//
//  Created by 千锋 on 16/9/14.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit

//个人资料
class ProfileViewController: UIViewController {

//    数据
    var profileModel:Profile?
    
    var tbView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人资料"
        self.view.backgroundColor = UIColor.whiteColor()
        createTableView()
        parsingData()
        
    }
    

    
//    请求数据
    func parsingData(){
//        获取登录成功状态值
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("uid") as! String
        let url = "http://10.0.8.8/sns/my/profile.php?uid="+uid
        SNSSessionDownloader.downloadWithUrl(url, finishClosure: {
            [weak self]
            (data) -> Void in
            let jsonData = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            if jsonData.isKindOfClass(NSDictionary){
                let dic = jsonData as! NSDictionary
//                解析
                self?.profileModel = Profile()
                self?.profileModel?.setValuesForKeysWithDictionary(dic as! Dictionary)
//                刷新表格
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.tbView?.reloadData()
                })
                
            }
            
        }) { (error) -> Void in
            MyUtil.showAlert(onViewController: self,msg: "获取失败---\(error)",nil)
        }
    }
    func createTableView(){
        self.automaticallyAdjustsScrollViewInsets = false
        tbView = UITableView(frame: CGRectMake(0, 64, 414, 672), style: .Plain)
        tbView?.delegate = self
        tbView?.dataSource = self
        self.view.addSubview(tbView!)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
//MARK: UItableView代理
extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("item")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "item")
        }
//        显示数据
        if profileModel != nil {
           
            if indexPath.row == 0{
                if let name = profileModel?.username {
                    cell?.textLabel?.text = "用户名："+name
                }else{
                    cell?.textLabel?.text = "用户名："+"用户名未填写"
                }
            }else if indexPath.row == 1{
                cell?.textLabel?.text = "出生地：" + (profileModel?.birthprovince)! + "-" + (profileModel?.birthcity)!
            }else if indexPath.row == 2 {
                cell?.textLabel?.text = "血型："+(profileModel?.blood)!+"型"
            }else if indexPath.row == 3{
                cell?.textLabel?.text = "邮箱："+(profileModel?.email)!
            }else if indexPath.row == 4{
                cell?.textLabel!.text = "居住地："+(profileModel?.resideprovince)!+"-"+(profileModel?.residecity)!
            }else if indexPath.row == 5{
                let urlString = "http://10.0.8.8/sns/" + (profileModel?.headimage)!
                let url = NSURL(string: urlString)
                cell?.imageView?.kf_setImageWithURL(url!)
            }
        }
        return cell!
    }
}
