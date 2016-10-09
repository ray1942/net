//
//  SNSDownloader.swift
//  SNS
//
//  Created by 千锋 on 16/9/13.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit

protocol SNSDownloaderDelegate:NSObjectProtocol{
    func downloader(download:SNSDownloader,didFailWithError error:NSError)
    func downloader(download:SNSDownloader,didFinishWithData data:NSData)
}
//下载类型
enum DownloadType:Int{
    case Register = 1 //注册
    case Login = 2   //登录
}
class SNSDownloader: NSObject {

    private lazy var receviceData = NSMutableData()
    weak var delegate:SNSDownloaderDelegate?
    
//    下载类型
    var type:DownloadType?
    
    
//    下载方法
    func downloadWithUrlString(urlString:String){
        
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        let conn = NSURLConnection(request: request, delegate: self)
        
    }
    
}
//MARK: NSURLConnect的代理
extension SNSDownloader:NSURLConnectionDataDelegate,NSURLConnectionDelegate{
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("请求失败")
        delegate?.downloader(self, didFailWithError: error)
    }
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
//        清空二进制对象 如果下载是一个snsdownload对象对应一次下载 那么可以不写 不进行清零
        receviceData.length = 0
        print("请求成功")
    }
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        receviceData.appendData(data)
        print("接收数据")
    }
    func connectionDidFinishLoading(connection: NSURLConnection) {
        print("请求完成")
        delegate?.downloader(self, didFinishWithData: receviceData)
    }
    
}