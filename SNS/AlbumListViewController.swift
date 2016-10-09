//
//  AlbumListViewController.swift
//  SNS
//
//  Created by 千锋 on 16/9/23.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit
import Alamofire

class AlbumListViewController: UIViewController {

    private lazy var dataArray = [Album]()
    var tbView:UITableView?
    
    func createTableView(){
        self.automaticallyAdjustsScrollViewInsets = false
        tbView = UITableView(frame: CGRectMake(0, 64, 414, 673), style: .Plain)
        tbView?.delegate = self
        tbView?.dataSource = self
        view.addSubview(tbView!)
    }
    
    
//    下载数据2
    func downloadData(){
        
        self.dataArray.removeAll()
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("uid") as! String
        
        let urlString = SysParam.MAIN_URL + "/album_list.php?uid="+uid
        Alamofire.request(.GET, urlString).responseJSON { (response) in
            switch response.result {
                
            case .Failure(let error):
                MyUtil.showAlert(onViewController: self, msg: error.localizedDescription, nil)
            case .Success(let json):
//                json解析
//              dataArray = Album.parseModel
                self.dataArray = Album.parseModel(json as! NSDictionary)
//                刷新表格
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print(self.dataArray)
                    self.tbView?.reloadData()
                })
                
            }
        }
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        createTableView()
        downloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        let barBtn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewAlbum")
        navigationItem.rightBarButtonItem = barBtn
        
    }
    func addNewAlbum(){
        
        let alert = UIAlertController(title: "新建相册", message: "请输入相册名", preferredStyle: .Alert)
        let confirm = UIAlertAction(title: "确定", style: .Default) { (action) -> Void in
//            发送请求
            if alert.textFields?.last?.text == nil {
                self.createAlbum("新建相册")
            }else{
                self.createAlbum((alert.textFields?.last?.text)!)
            }
        }
        alert.addAction(confirm)
        
//        添加输入框
        alert.addTextFieldWithConfigurationHandler { (tf) -> Void in
            tf.placeholder = "相册名"
            tf.text = "新建相册"
        }
        
        let cancel = UIAlertAction(title: "取消", style: .Destructive) { (action) -> Void in
            
        }
        alert.addAction(cancel)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
//    发送新建相册请求
    func createAlbum(name:String){
        
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("uid") as! String
        let urlString = "http://10.0.8.8/sns/my/create_album.php?uid=\(uid)&albumname=\(name)&privacy=0"
//        print(name)
        Alamofire.request(.GET, urlString).responseJSON { (response) -> Void in
            switch response.result {
            case .Failure(let error):
                MyUtil.showAlert(onViewController: self, msg: error.localizedDescription, nil)
            case .Success(let json):
                let dict = json as! Dictionary<String,AnyObject>
                let code = dict["code"] as! String
                let msg = dict["message"] as! String
                MyUtil.showAlert(onViewController: self, msg: msg, nil)
                if code == "do_success" {
//                    重写请求数据
                    self.downloadData()
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension AlbumListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("item")
        if cell == nil{
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "item")
        }
        
        cell?.textLabel?.text = dataArray[indexPath.row].albumname
        cell?.detailTextLabel?.text = "\(dataArray[indexPath.row].pics!)张"
        
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataArray[indexPath.row]
        let avc = AlbumViewController()
        avc.albumId = model.id
        navigationController?.pushViewController(avc, animated: true)
        
    }
}