//
//  BadgeViewController.swift
//  Coursepad
//
//  Created by Nazri Hussein on 5/8/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import AlamofireSwiftyJSON
import SwiftyJSON
import Kingfisher

class BadgeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var badgeArray : [JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if let token = UserDefaults.standard.string(forKey: "token"){
            
        let listURL = URL(string:"http://ec2-54-254-137-23.ap-southeast-1.compute.amazonaws.com/backend/public/index.php/api/badgesbyUser?token=\(token)")
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
                        self.badgeArray = dataToShow["data"].arrayValue
                        self.collectionView.reloadData()
                    }
                }
                
        }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badgeArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath) as! BadgeCollectionViewCell
        let imageName = badgeArray[indexPath.row]        ["logo"].stringValue

        let imageURLString = "http://ec2-54-254-137-23.ap-southeast-1.compute.amazonaws.com/backend/storage/app/public/\(imageName)"
        let imageURL = URL(string:imageURLString)!
        cell.logoImageView.kf.setImage(with: imageURL)
        // Configure the cell
        return cell
    }
    
    @IBAction func closePressed(_ sender: Any) {
                
        self.dismiss(animated: true, completion: nil)

    }
  
}
