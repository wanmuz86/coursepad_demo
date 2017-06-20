//
//  CourseDetailViewController.swift
//  Coursepad
//
//  Created by Nazri Hussein on 2/26/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireSwiftyJSON
import MBProgressHUD
class CourseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var courseJSON : JSON!
    var logoImage : UIImage!
    var lessonArray : [JSON] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:UIBarButtonItemStyle.plain, target:nil, action:nil)
      //  self.title = courseJSON["name"].stringValue
        if let token = UserDefaults.standard.string(forKey: "token"){
        let urlString = "http://ec2-54-254-137-23.ap-southeast-1.compute.amazonaws.com/backend/public/index.php/api/lessonByUser?token=\(token)"
        let listURL = URL(string:urlString)
        let parameters: Parameters = [ "course_id": courseJSON["id"].stringValue]
        MBProgressHUD.hide(for: self.view, animated: true)
        Alamofire.request(listURL!, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseSwiftyJSON { dataResponse in
                
                if (dataResponse.error != nil) {
                    print(dataResponse.error)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }
                else {
                    if let dataToShow = dataResponse.value {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.lessonArray = dataToShow["completedLesson"].arrayValue
                        self.tableView.reloadData()
                    }
                }
                
        }
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath) as! BannerTableViewCell
            cell.logoImageView.image = logoImage
            return cell
        }
        else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LessonTableViewCell
            cell.titleLabel?.text = lessonArray[indexPath.row - 1]["title"].stringValue
            
            if lessonArray[indexPath.row-1]["completed"].intValue == 0 {
                cell.tickImageView.isHidden = true
            }
            return cell
        }
     
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + lessonArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        }
        else {
            return 50
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toLesson" {
                let selectedIndexPath = tableView.indexPathForSelectedRow
                let selectedLesson = lessonArray[selectedIndexPath!.row-1]
                let destVC = segue.destination as! LessonWebViewController
                destVC.selectedLesson = selectedLesson
            }
            
        }
    
    @IBAction func closePressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
