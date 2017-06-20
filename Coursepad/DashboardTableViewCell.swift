//
//  DashboardTableViewCell.swift
//  Coursepad
//
//  Created by Nazri Hussein on 2/25/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var courseDec: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
