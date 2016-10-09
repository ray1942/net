//
//  UserListViewController.swift
//  SNS
//
//  Created by 千锋 on 16/9/19.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserListViewController: UIViewController {

    lazy var dataArray = Array<User>()
    
    var tbView: UITableView?
    
    
    func createTableView(){
        self.automaticallyAdjustsScrollViewInsets = false
        tbView = UITableView(frame: CGRectMake(0, 64, 414, 673), style: .Plain)
        tbView?.delegate = self
        tbView?.dataSource = self
        let nib = UINib(nibName: "UserCell", bundle: nil)
        tbView?.registerNib(nib, forCellReuseIdentifier: "userCellId")
        self.view.addSubview(tbView!)
    }
    
    func downloadData(){
        let urlString = "http://10.0.8.8/sns/my/user_list.php"
        Alamofire.request(.GET, urlString).responseData {
            [weak self]
            (response) in
            
            switch response.result{
            case .Failure(let error):
                MyUtil.showAlert(onViewController: self!, msg: error.localizedDescription, nil)
            case .Success:
                self!.dataArray = User.parseModel(response.data!)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self!.tbView?.reloadData()
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        createTableView()
        downloadData()
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension UserListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCellId", forIndexPath: indexPath) as! UserCell
        cell.configModel(dataArray[indexPath.row])
        return cell
        
    }
}