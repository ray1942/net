//
//  SNSSessionDownloader.swift
//  SNS
//
//  Created by 千锋 on 16/9/14.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit

protocol SNSSessionDownloaderDelegate:NSObjectProtocol{
//    下载失败
    func sessionDownloader(downloader:SNSSessionDownloader,didFailWithError error:NSError)
//    成功
    func sessionDownloader(downloader:SNSSessionDownloader,didFinishWithData data:NSData)
}

class SNSSessionDownloader: NSObject {

////    闭包封装的下载方法
//    var finishClosure:(NSData->Void)
//    var failClosure:(NSError->Void)
//    代理属性
    weak var delegate:SNSSessionDownloaderDelegate?
    
//    POST请求，用代理处理 返回的数据
    func postWithUrl(urlString:String,parameter:[String:AnyObject]?){
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        /*dic == ["name":"jack","age":12]
            str == "name=jack&age=20"
        */
        request.HTTPMethod = "POST"
        
        var str = String()
        if let tmp = parameter{
            for (key,val) in tmp{
                let tmpVal = val as! NSObject
                if str.characters.count == 0{
//                    如果是第一个 前面不加&
                    str = str.stringByAppendingFormat("%@=%@", key,tmpVal)
                }else{
//                    第二个开始加&
                    str = str.stringByAppendingFormat("&%@=%@", key,tmpVal)
                }
            }
        }
        
        let data = str.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = data
       
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            if let tmpError = error {
                
                print(tmpError)
                self.delegate?.sessionDownloader(self, didFailWithError: tmpError)
                
            }else{
                
                let httpResponse = response as! NSHTTPURLResponse
                if httpResponse.statusCode == 200{
                        self.delegate?.sessionDownloader(self, didFinishWithData: data!)
                }else{
                    let myError = NSError(domain: urlString, code: httpResponse.statusCode, userInfo: ["msg":"下载失败"])
                    self.delegate?.sessionDownloader(self, didFailWithError: myError)
                    print("请求失败")
                }
            }
            
        }
        task.resume()
        
    }
    
    
    class func downloadWithUrl(urlString:String,finishClosure:(NSData->Void),failClosure:(NSError->Void)){
        
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let tmpError = error{
                failClosure(tmpError)
            }else{
                let httpResponse = response as! NSHTTPURLResponse
                if httpResponse.statusCode == 200 {
                    finishClosure(data!)
                }else{
                    let myError = NSError(domain: urlString, code: httpResponse.statusCode, userInfo: ["msg":"下载失败"])
                    failClosure(myError)
                }
            }
        }
        task.resume()
    }
}
