//
//  FriendListViewController.swift
//  SNS
//
//  Created by 千锋 on 16/9/18.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//好友列表界面
class FriendListViewController: UIViewController {
    
    private lazy var dataArray = Array<Friend>()
    var tbView:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "好友列表"
        prepareView()
        downloadData()
    }
//    请求数据 
    func downloadData(){
//        token
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("uid") as! String
        
//        m_auth比uid更安全 uid跟用户一一对应
        
        Alamofire.request(.POST, SysParam.FriendList, parameters: ["uid":uid], encoding: ParameterEncoding.URL, headers: nil).responseJSON {
            [weak self]
            (response) in
            /*if self == nil {
                return
            }*/
            
            switch response.result{
            case .Failure(let error):
                MyUtil.showAlert(onViewController: self!, msg: "获取列表失败\(error.description)", nil)
            case .Success(let jsonData):
                let json = JSON(jsonData)
                for (_,val) in json {
                    
//                    创建一个模型对象
                    let model = Friend()
                    model.group = val["group"].string
                    model.groupid = val["groupid"].string
                    model.lastactivity = val["lastactivity"].number
                    model.uid = val["uid"].string
                    model.username = val["username"].string
//                    model.setValuesForKeysWithDictionary(val as)
                    if self != nil {
                        self!.dataArray.append(model)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self?.tbView?.reloadData()
            })
        }
    }

    func prepareView(){
        
        self.automaticallyAdjustsScrollViewInsets = false
        tbView = UITableView(frame: CGRectMake(0, 64, 414, 672), style: .Plain)
        tbView?.delegate = self
        tbView?.dataSource = self
        let nib = UINib(nibName: "FriendCell", bundle: nil)
        tbView?.registerNib(nib, forCellReuseIdentifier: "friendCellId")
        self.view.addSubview(tbView!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
extension FriendListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCellId", forIndexPath: indexPath) as! FriendCell
        cell.configModel(dataArray[indexPath.row])
        return cell
    }
}
