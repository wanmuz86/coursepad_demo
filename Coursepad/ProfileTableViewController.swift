//
//  ProfileTableViewController.swift
//  Coursepad
//
//  Created by Nazri Hussein on 4/2/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import Alamofire
import AlamofireSwiftyJSON
import MBProgressHUD

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(loadUser),
                       name: NSNotification.Name(rawValue: "loadUser"),
                       object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        }
        else {
            if indexPath.row == 4 {
                let sharedInstance = UserDefaults.standard
                sharedInstance.removeObject(forKey: "token")
                sharedInstance.synchronize()
                self.tabBarController?.selectedIndex = 0
            }
        }
    }
    func loadUser(){
        if let token = UserDefaults.standard.string(forKey: "token"){
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)"
            ]
            
            let listURL = URL(string:"http://ec2-54-254-137-23.ap-southeast-1.compute.amazonaws.com/backend/public/index.php/api/getUser?token=\(token)")
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Alamofire.request(listURL!, method: .post, parameters: nil, encoding: URLEncoding.default)
                .responseSwiftyJSON { dataResponse in
                    
                    if (dataResponse.error != nil) {
                        print(dataResponse.error)
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    else {
                        if let dataToShow = dataResponse.value {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.nameLbl.text = dataToShow["data"]["name"].stringValue
                            let url = URL(string: dataToShow["data"]["avatar"].stringValue)
                            self.imageView.kf.setImage(with: url)
                        }
                    }
                    
            }
    }
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditProfile"{
            let destNavVC = segue.destination as! UINavigationController
            let destVC = destNavVC.topViewController as! EditProfileViewController
            destVC.username = nameLbl.text!
        }
    }
}
