//
//  AlbumViewController.swift
//  SNS
//
//  Created by 千锋 on 16/9/23.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AlbumViewController: UITableViewController {

    var albumId:String?
    lazy var dataArray = [Photo]()
    
    func downloadData(){
        
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("uid") as! String
        let urlString = SysParam.MAIN_URL+"/photo_list.php?uid=\(uid)&id=\(albumId!)"
        Alamofire.request(.GET, urlString).responseJSON { (response) -> Void in
            switch response.result{
            case .Failure(let error):
                MyUtil.showAlert(onViewController: self, msg: error.localizedDescription, nil)
            case .Success(let json):
                self.dataArray = Photo.parseModel(json as! (NSDictionary))
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        downloadData()
        let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPhoto")
        navigationItem.rightBarButtonItem = add
        
        
        
    }
//    上传图片
    func addPhoto(){
        
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("uid") as! String
        let urlString = SysParam.MAIN_URL+"/upload_photo.php?uid=\(uid)&albumid=\(albumId!)"
        Alamofire.upload(.POST, urlString, multipartFormData: { (formData) -> Void in
            
//            图片
            let path = NSBundle.mainBundle().pathForResource("contentview_hd_loading", ofType: ".gif")
            let data = NSData(contentsOfFile: path!)
            formData.appendBodyPart(data: data!,name:"attach",fileName:"contentview_hd_loading.gif",mimeType:"image/gif")//jpg->jpeg
            
            }) { (result) -> Void in
                
                switch result{
                case .Failure(let error):
                    MyUtil.showAlert(onViewController: self, msg: "上传失败: \(error)", nil)
                case .Success(let request,_,_):
                   request.responseJSON(completionHandler: { (response) -> Void in
//                    let str = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                    let json = JSON(data: response.data!)
                    
                    let code = json["code"].string
                    let msg = json["message"].string
                    if code == "do_success" {
                        self.downloadData()
                    }
                        MyUtil.showAlert(onViewController: self, msg: msg!, nil)
                    
                   })
                }
                
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("item")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "item")
        }
        let model = dataArray[indexPath.row]
        cell?.textLabel?.text = model.albumid
        let urlString = String(format: "http://10.0.8.8/sns/%@", model.pic_origin!)
        print(urlString)
        
        cell?.imageView?.kf_setImageWithURL(NSURL(string: urlString)!,placeholderImage: UIImage(named: "045"))
        
        return cell!
    }
    

}
