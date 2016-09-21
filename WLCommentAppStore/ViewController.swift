//
//  ViewController.swift
//  WLCommentAppStore
//
//  Created by wanli on 16/9/21.
//  Copyright © 2016年 wanli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        WLCommentAppstore.toAppstoreComment(vc: self, appidStr: "1032652386")
    }


}

