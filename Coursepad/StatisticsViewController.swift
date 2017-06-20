//
//  StatisticsViewController.swift
//  Coursepad
//
//  Created by Metech3 on 10/05/2017.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var scoreLbl: UILabel!
    var score : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scoreLbl.text = "Points: \(String(describing: score!))"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
