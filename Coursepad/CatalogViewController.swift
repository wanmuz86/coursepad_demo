//
//  CatalogViewController.swift
//  Coursepad
//
//  Created by Nazri Hussein on 4/2/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit
import AlamofireSwiftyJSON
import Alamofire
import SwiftyJSON
import Kingfisher

class CatalogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var courseArray : [JSON] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCatalog()
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(loadCatalog),
                       name: NSNotification.Name(rawValue: "loadCatalog"),
                       object: nil)

            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CatalogTableViewCell
        cell.titleLabel.text = courseArray[indexPath.row]["title"].stringValue

        let imageName = courseArray[indexPath.row]["course_logo"].stringValue
        let imageURLString = "http://ec2-54-254-137-23.ap-southeast-1.compute.amazonaws.com/backend/storage/app/public/\(imageName)"
        let imageURL = URL(string:imageURLString)!
        cell.logoImageView.kf.setImage(with: imageURL)
        if courseArray[indexPath.row]["price"].stringValue == ""{
            
       cell.priceLbl.text = "Free"
        }
        else{
            cell.priceLbl.text = courseArray[indexPath.row]["price"].stringValue
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCatalog" {
            let destVC = segue.destination as! CourseCatTableViewController
            let selectedIndex = self.tableView.indexPathForSelectedRow!
            destVC.courseInfo = courseArray[selectedIndex.row]
            destVC.logoImage = (self.tableView.cellForRow(at: selectedIndex) as! CatalogTableViewCell).logoImageView.image
        }
    }
    
    func loadCatalog(){
        if let token = UserDefaults.standard.string(forKey: "token"){
            
            let listURL = URL(string:"http://ec2-54-254-137-23.ap-southeast-1.compute.amazonaws.com/backend/public/index.php/api/usercatalog?token=\(token)")
            
            Alamofire.request(listURL!, method: .post, parameters: nil, encoding: URLEncoding.default)
                .responseSwiftyJSON { dataResponse in
                    
                    if (dataResponse.error != nil) {
                        print(dataResponse.error)
                
                    }
                    else {
                        if let dataToShow = dataResponse.value {
                            self.courseArray = dataToShow["data"].arrayValue
                            self.tableView.reloadData()
                        }
                    }
            }
        }
    }
}
