//
//  LessonWebViewController.swift
//  Coursepad
//
//  Created by Nazri Hussein on 3/29/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON
import MBProgressHUD
class LessonWebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    var selectedLesson : JSON!
    var lessonInfo :JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:UIBarButtonItemStyle.plain, target:nil, action:nil)
        self.title = selectedLesson["title"].stringValue
        
        let htmlString = self.selectedLesson?["content"].stringValue
        self.webView.loadHTMLString(htmlString!, baseURL: nil)
        if selectedLesson?["completed"].intValue == 0 {
            if let token = UserDefaults.standard.string(forKey: "token"){

            let listUpdateURL = URL(string:"http://ec2-54-254-137-23.ap-southeast-1.compute.amazonaws.com/backend/public/index.php/api/updateLesson?token=\(token)")
        let parameters: Parameters = ["lesson_id": selectedLesson["id"].stringValue ]
        Alamofire.request(listUpdateURL!, method: .post, parameters: parameters, encoding: URLEncoding.default).debugLog()
            .responseSwiftyJSON { dataResponse in
        
            
                if (dataResponse.error != nil) {
                    print(dataResponse.error)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }
                else {
                    if let dataToShow = dataResponse.value {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let ns =  NotificationCenter.default
                        ns.post(name: Notification.Name(rawValue: "loadData"), object: nil)
                        }
                }
                    }
        }
                
        }
    }
    



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
