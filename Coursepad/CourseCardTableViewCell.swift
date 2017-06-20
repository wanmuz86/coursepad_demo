//
//  CourseCardTableViewCell.swift
//  Coursepad
//
//  Created by Nazri Hussein on 3/28/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit
import GTProgressBar
class CourseCardTableViewCell: UITableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var progressBar: GTProgressBar!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
