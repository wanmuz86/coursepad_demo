//
//  QuizViewController.swift
//  Coursepad
//
//  Created by Metech3 on 10/05/2017.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MBProgressHUD

class QuizViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var questionLbl: UILabel!
    

    @IBOutlet weak var tableView: UITableView!
    var questionCount = 0
    var score = 0;
    
    var questionsArr : [JSON] =  []
    override func viewDidLoad() {
        super.viewDidLoad()
        let listURL = URL(string:"http://ec2-54-254-137-23.ap-southeast-1.compute.amazonaws.com/backend/public/index.php/api/quizbycourse/1")
        
        Alamofire.request(listURL!, method: .get, parameters: nil, encoding: URLEncoding.default)
            .responseSwiftyJSON { dataResponse in
                
                if (dataResponse.error != nil) {
                    print(dataResponse.error)
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                else {
                    if let dataToShow = dataResponse.value {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.questionsArr = dataToShow["data"].arrayValue

                               self.refreshQuestion()
                    }
                }
                
        }

 
     
        
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func refreshQuestion() {
        
        self.questionLbl.text = questionsArr[questionCount]["question"].stringValue
       self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = questionsArr[questionCount][
            "options"][indexPath.row]["text"].stringValue
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questionsArr.count > 0{
             return 4
        }
       
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if questionsArr[questionCount][
            "options"][indexPath.row]["iscorrect"].intValue == 1 {
            score += 1
            print("correct")
        }
        else {
            print("wrong")
        }
        questionCount += 1
        if questionCount < questionsArr.count {
            refreshQuestion()
        }
        else {
            print("game Over")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let statsVC = storyboard.instantiateViewController(withIdentifier: "StatisticsVC") as! StatisticsViewController
            statsVC.score = score
            self.navigationController!.pushViewController(statsVC, animated: true)
            
        }

    }
}
