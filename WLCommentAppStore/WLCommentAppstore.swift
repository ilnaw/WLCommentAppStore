//
//  WLCommentAppstore.swift
//  SwiftPackagingDemo
//
//  Created by wanli on 16/9/20.
//  Copyright © 2016年 wanli. All rights reserved.
//

import UIKit
import Foundation

//第一次进入app时候，应该判断 5天后才显示提示框

private let oneDay : Double = 86400
class WLCommentAppstore: NSObject {
    

   ///  跳转appStore评论
   ///
   /// - parameter vc:       控制器
   /// - parameter appidStr: appid
   class func toAppstoreComment(vc : UIViewController,appidStr : String){
        let appDic = Bundle.main.infoDictionary;
        let appVersion  = appDic?["CFBundleShortVersionString"] as? String
        let userDefaut = UserDefaults.standard;
        let commentDay = userDefaut.object(forKey: "commentDay") as? Int
        let localVersion = userDefaut.object(forKey: "localVersion") as? String
        let userChoose = userDefaut.object(forKey: "userChoose") as? Int
        
       //如果第一次登陆app 要5天后才弹出评论
        guard let first = userDefaut.object(forKey: "firstComment") as? Double else  {
            userDefaut.set(Date.init().timeIntervalSince1970 + oneDay * 5, forKey: "firstComment")
            return;
        }
        let nowTime = Date().timeIntervalSince1970
        if nowTime < first {
            return;
        }

    
        //当前天数
        let interval = Date.init().timeIntervalSince1970
        let today = interval / oneDay
        
        guard let kUserChoose = userChoose  else {
            //新下载 直接去评论
            gotoAppstoreComment(vc: vc,appid:appidStr)
            return;
        }
        if appVersion?.compare(localVersion!) == .orderedDescending{

            //新版本 清空userdefault
            userDefaut.removeObject(forKey: "commentDay")
            userDefaut.removeObject(forKey: "localVersion")
            userDefaut.removeObject(forKey: "userChoose")
            
            //加5天
            userDefaut.set(Date.init().timeIntervalSince1970 + oneDay * 5, forKey: "firstComment")
        }
        else{
            //判断是否去评论  1 = 残忍拒绝 30天后再提醒
            //好评不在弹出
            //差评不在弹出
            //残忍拒绝 30天后再探出
            
            if kUserChoose == 1 && Int(today) - commentDay! > 30 {
              //评论
             gotoAppstoreComment(vc: vc,appid:appidStr)
            }
        }
    
    }
    
    ///  跳转appStore评论
    ///
    /// - parameter vc:       控制器
    /// - parameter appidStr: appid
   private class func gotoAppstoreComment(vc : UIViewController,appid : String) {
        let appDic = Bundle.main.infoDictionary;
        let appVersion  = appDic?["CFBundleShortVersionString"] as? String
        let userDefaut = UserDefaults.standard;
              
        //当前天数
        let interval = Date.init().timeIntervalSince1970
        let today = interval / oneDay
        
        //更新版本号
        userDefaut.set(appVersion, forKey: "localVersion")
        //设置评论时间
        userDefaut.set(today, forKey: "commentDay")
        
        let alertController = UIAlertController.init(title: "给用户的一封信", message: "有了您的支持才能更好的为您服务，提供更加优质的，更加适合您的App，当然您也可以直接反馈问题给到我们", preferredStyle: .alert)
        
        let alertAction1 = UIAlertAction.init(title: "好用，好评！", style: .default) { (action : UIAlertAction) in
            //设置选项
            userDefaut.set(2, forKey: "userChoose")
            //跳转评论
            let url = "https://itunes.apple.com/cn/app/id\(appid)?mt=8"
            UIApplication.shared.open(NSURL.init(string: url) as! URL, options: [:], completionHandler: nil);
            
            
        };
        
        let alertAction2 = UIAlertAction.init(title: "差评！", style: .default) { (action : UIAlertAction) in
            //设置选项
            userDefaut.set(3, forKey: "userChoose")
            //跳转评论
            let url = "https://itunes.apple.com/cn/app/id\(appid)?mt=8"
            UIApplication.shared.open(NSURL.init(string: url) as! URL, options: [:], completionHandler: nil);
            

        };
        
        let alertAction3 = UIAlertAction.init(title: "残忍拒绝", style: .default) { (action : UIAlertAction) in
            //设置选项
            userDefaut.set(1, forKey: "userChoose")
        };
        
        alertController.addAction(alertAction1);
        alertController.addAction(alertAction2);
        alertController.addAction(alertAction3);
        vc.present(alertController, animated: true, completion: nil);
    }
}
