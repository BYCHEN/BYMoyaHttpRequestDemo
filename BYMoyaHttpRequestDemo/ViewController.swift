//
//  ViewController.swift
//  BYMoyaHttpRequestDemo
//
//  Created by by_chen on 2017/6/21.
//  Copyright © 2017年 BYChen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 如何使用Rest API Reqeust
        
        //  創建一個Photo
        if let image = UIImagePNGRepresentation(UIImage(named: "ImageFile")!) {
            RestAPIReqeust.createPhoto(image: image).execute()
        }
        
        //  取得某個Photo
        RestAPIReqeust.photo(objectId: "abcdId").execute()
        
        // 更新某個Photo
        RestAPIReqeust.putPhoto(objectId: "abcdId", title: "New Title", description: "New Description").execute()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

