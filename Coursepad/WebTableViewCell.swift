//
//  WebTableViewCell.swift
//  Coursepad
//
//  Created by Nazri Hussein on 3/19/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit

class WebTableViewCell: UITableViewCell {

    @IBOutlet weak var webView: UIWebView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
