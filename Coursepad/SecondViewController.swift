//
//  SecondViewController.swift
//  Coursepad
//
//  Created by Nazri Hussein on 2/24/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import AlamofireSwiftyJSON
import Alamofire
import SwiftyJSON
import Kingfisher
import QuartzCore
import MBProgressHUD

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var courseArray : [JSON] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(loadData),
                       name: NSNotification.Name(rawValue: "loadData"),
                       object: nil)
        loadData()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated:Bool){
    
        let currentUser = UserDefaults.standard.string(forKey: "token")
        if (currentUser == nil ) {
            DispatchQueue.main.async(execute: { () -> Void in
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
                self.present(viewController, animated: true, completion: nil)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CourseCardTableViewCell
        cell.descLabel.text = courseArray[indexPath.row]["title"].stringValue
       // cell.courseDec.text = courseArray[indexPath.row]["description"].stringValue
        let imageURL = URL(string:courseArray[indexPath.row]["image"].stringValue)
       
        cell.bannerImageView.kf.setImage(with: imageURL)
     //   cell.videoPlayerItem = AVPlayerItem.init(url: URL(string:"http://www.ebookfrenzy.com/ios_book/movie/movie.mov")!)
        cell.cardView.layer.borderColor = Color.darkGray.cgColor
        cell.cardView.layer.shadowColor = Color.black.cgColor
        cell.cardView.layer.shadowOpacity = 0.8
        cell.cardView.layer.shadowRadius = 3.0
        cell.cardView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cell.progressBar.barBackgroundColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:0.5)
        cell.progressBar.barBorderColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        cell.progressBar.barFillColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        cell.progressBar.progress = CGFloat(courseArray[indexPath.row]["completion"].floatValue)
        return cell
    }
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let selectedIndexPath = tableView.indexPathForSelectedRow
            let selectedLesson = courseArray[selectedIndexPath!.row]
            let destTab = segue.destination as! UITabBarController
            let destNav = destTab.viewControllers?[0] as! UINavigationController
            let destVC = destNav.topViewController as! CourseDetailViewController
            destVC.logoImage = (tableView.cellForRow(at: selectedIndexPath!) as! CourseCardTableViewCell).bannerImageView.image
            destVC.courseJSON = selectedLesson
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 315
    }
    func loadData(){
        if let token = UserDefaults.standard.string(forKey: "token"){
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)"
            ]
          
                let listURL = URL(string:"http://ec2-54-254-137-23.ap-southeast-1.compute.amazonaws.com/backend/public/index.php/api/coursesbyUser?token=\(token)")
                MBProgressHUD.showAdded(to: self.view, animated: true)
                        Alamofire.request(listURL!, method: .post, parameters: nil, encoding: URLEncoding.default, headers:headers)
                            .debugLog()
                    .responseSwiftyJSON { dataResponse in
                        
                        if (dataResponse.error != nil) {
                            print(dataResponse.error)
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        else {
                            if let dataToShow = dataResponse.value {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.courseArray = dataToShow["data"].arrayValue
                                self.tableView.reloadData()
                            }
                        }
                }
            
            }
    }
}
