//
//  EditProfileViewController.swift
//  Coursepad
//
//  Created by Metech3 on 6/7/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON
import MBProgressHUD

class EditProfileViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    var username : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = username
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func barButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonPressed(_ sender: Any) {
        
        if let token = UserDefaults.standard.string(forKey: "token"){
            let params : Parameters = ["name": nameTextField.text!]
            let listURL = URL(string:"http://ec2-54-254-137-23.ap-southeast-1.compute.amazonaws.com/backend/public/index.php/api/updateUser?token=\(token)")
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Alamofire.request(listURL!, method: .post, parameters: params, encoding: URLEncoding.default)
                .responseSwiftyJSON { dataResponse in
                    if (dataResponse.error != nil) {
                        print(dataResponse.error)
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    else {
                        if let dataToShow = dataResponse.value {
                            let ns =  NotificationCenter.default
                            ns.post(name: Notification.Name(rawValue: "loadUser"), object: nil)
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.navigationController?.dismiss(animated: true, completion: nil)
                        }
                    }
            }
        }
        
    }

}
