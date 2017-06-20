//
//  RegisterViewController.swift
//  Coursepad
//
//  Created by Metech3 on 5/29/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireSwiftyJSON
import Kingfisher
import SwiftyJSON
import MBProgressHUD
class RegisterViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
    }

    
    func hideKeyboard(){
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }

    @IBAction func registerPressed(_ sender: Any) {
        
        let parameters: Parameters = [ "username": emailTextField.text!, "password":passwordTextField.text!, "name": nameTextField.text!]
        let loginURL = URL(string:"http://ec2-54-254-137-23.ap-southeast-1.compute.amazonaws.com/backend/public/index.php/api/login")
        Alamofire.request(loginURL!, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseSwiftyJSON { dataResponse in
                
                if (dataResponse.error != nil) {
                    print(dataResponse.error)
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                else {
                    if let dataToShow = dataResponse.value {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if dataToShow["status"].stringValue == "ok"{
                            print("ok")
                            let userDefaults = UserDefaults.standard
                            userDefaults.set(dataToShow["user"].object, forKey: "user")
                            userDefaults.synchronize()
                            let ns =  NotificationCenter.default
                            ns.post(name: Notification.Name(rawValue: "loadData"), object: nil)
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                        else {
                            print("error")
                        }
                    }
                }
                
        }

    }
}
