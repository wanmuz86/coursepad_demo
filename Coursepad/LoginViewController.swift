//
//  LoginViewController.swift
//  Coursepad
//
//  Created by Metech3 on 5/22/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireSwiftyJSON
import MBProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!
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
    
    @IBAction func loginPressed(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let parameters: Parameters = [ "email": emailTextField.text!, "password":passwordTextField.text!]
        let loginURL = URL(string:"http://ec2-54-254-137-23.ap-southeast-1.compute.amazonaws.com/backend/public/index.php/api/authenticate")
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
                            userDefaults.set(dataToShow["token"].object, forKey: "token")
                            userDefaults.synchronize()
                           let ns =  NotificationCenter.default
                            ns.post(name: Notification.Name(rawValue: "loadData"), object: nil)
                            ns.post(name: Notification.Name(rawValue: "loadCatalog"), object: nil)
                            ns.post(name: Notification.Name(rawValue: "loadUser"), object: nil)
                            self.dismiss(animated: true, completion: nil)
                            
                            
                        }
                        else if dataToShow["status"].stringValue == "error"{
                        let alert = UIAlertController(title: "Error", message: dataToShow["message"].stringValue, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                        else{
                            print("error")
                        }
                    }
                }
                
        }
        
    }

    func hideKeyboard(){
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
}
