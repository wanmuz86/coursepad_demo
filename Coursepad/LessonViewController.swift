//
//  LessonViewController.swift
//  Coursepad
//
//  Created by Nazri Hussein on 2/26/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireSwiftyJSON
import AVKit
import AVFoundation
import MBProgressHUD

class LessonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var selectedLesson : JSON!
    var lessonInfo :JSON?
    var courseVideos: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedLesson)
        let loginURL = URL(string:"http://ec2-52-221-207-144.ap-southeast-1.compute.amazonaws.com/api/login/")
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(loginURL!, method: .post, parameters: nil, encoding: URLEncoding.default)
            .responseSwiftyJSON { dataResponse in
                
                if (dataResponse.error != nil) {
                    print(dataResponse.error)
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                else {
                    if let dataToShow = dataResponse.value {
                        self.lessonInfo = dataToShow
                        print(self.lessonInfo)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if dataToShow["videos"].arrayValue.count > 0{
                            self.courseVideos = dataToShow["videos"].arrayValue
                        }
                        self.tableView.reloadData()
                    }
                }
                
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescCell", for: indexPath)
        
        
        return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WebCell", for: indexPath) as! WebTableViewCell
            let htmlString = lessonInfo?["content"].stringValue
            cell.webView.loadHTMLString(htmlString!, baseURL: nil)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = courseVideos[indexPath.row-2]["file_name"].stringValue
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (lessonInfo != nil){
        return courseVideos.count + 2
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 200
        }
        else {
            return 44
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVideo"{
            let selectedindexPath = self.tableView.indexPathForSelectedRow!
        let imageName = courseVideos[selectedindexPath.row-2]["file_url"].stringValue
        let folder1 = (imageName as NSString).substring(with: NSMakeRange(0,3))
        let folder2 = (imageName as NSString).substring(with: NSMakeRange(3,3))
        let folder3 = (imageName as NSString).substring(with: NSMakeRange(6,3))
        let videoURLString = "http://ec2-54-254-137-23.ap-southeast-1.compute.amazonaws.com/october/storage/app/uploads/public/\(folder1)/\(folder2)/\(folder3)/\(imageName)"
        let destination = segue.destination as! AVPlayerViewController
        let url = URL(string:
            videoURLString)
        
        if let movieURL = url {
            destination.player = AVPlayer(url: movieURL)
        }
        }
    }
}
