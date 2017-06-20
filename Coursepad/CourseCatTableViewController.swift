//
//  CourseCatTableViewController.swift
//  Coursepad
//
//  Created by Metech3 on 5/29/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class CourseCatTableViewController: UITableViewController {
    var courseId : Int?
    var courseInfo : JSON?
    var logoImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 2
        }
        else {
            return 1
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath) as! CatBannerTableViewCell
                cell.bannerImageView.image = self.logoImage
                // Configure the cell...
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! CatInfoTableViewCell
                cell.titleLbl.text = courseInfo!["title"].stringValue
                // Configure the cell...
                cell.buyButton.backgroundColor = UIColor(red: 37.0/255.0, green: 162.0/255.0, blue: 97.0/255.0, alpha: 1)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buyPressed))
                
                cell.buyButton.addGestureRecognizer(tapGesture)
                if courseInfo!["price"].stringValue == ""{
                    cell.priceLbl.text = "Free"
                }
                else
                {
                cell.priceLbl.text = "RM \(String(describing: courseInfo!["price"].stringValue))"
                
                }
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescCell", for: indexPath) as! CatDescTableViewCell
            cell.webView.loadHTMLString((courseInfo?["desc"].stringValue)!, baseURL: nil)
                // Configure the cell...
                
                return cell
        }
    }
    
    
    func buyPressed(){
        let messageToShow = "Are you sure you want to purchase \(courseInfo!["title"].stringValue) for RM \(courseInfo!["price"].stringValue)  ?"
        let alertToShow = UIAlertController(title: "Are you sure?", message: messageToShow, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
          if let token = UserDefaults.standard.string(forKey: "token")
            {
              let parameters: Parameters = ["course_id": self.courseInfo!["id"].intValue]
            let listURL = URL(string:"http://ec2-54-254-137-23.ap-southeast-1.compute.amazonaws.com/backend/public/index.php/api/purchasecourse?token=\(token)")
            
            Alamofire.request(listURL!, method: .post, parameters: parameters, encoding: URLEncoding.default)
                .responseSwiftyJSON { dataResponse in
                    
                    if (dataResponse.error != nil) {
                        print(dataResponse.error)
                        
                    }
                    else {
                        if let dataToShow = dataResponse.value {
                            if dataToShow["status"] == "ok"{
                                let ns =  NotificationCenter.default
                                ns.post(name: Notification.Name(rawValue: "loadData"), object: nil)
                                ns.post(name: Notification.Name(rawValue: "loadCatalog"), object: nil)
                                ns.post(name: Notification.Name(rawValue: "loadUser"), object: nil)
                                let alertSucces = UIAlertController(title: "Purchase Succesful", message: "Purchase Succesful. You may start browsing the course on My Courses tab.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                                    self.navigationController?.popViewController(animated: true)
                                    self.tabBarController?.selectedIndex = 0
                                    
                                })
                                alertSucces.addAction(okAction)
                                self.present(alertSucces, animated: true, completion: nil)
                                print("purchase ok")
                            }
                                                   }
                    }
                    
            }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertToShow.addAction(okAction)
        alertToShow.addAction(cancelAction)
        present(alertToShow, animated: true, completion: nil)
    }

}

