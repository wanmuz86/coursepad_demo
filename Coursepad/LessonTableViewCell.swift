//
//  LessonTableViewCell.swift
//  Coursepad
//
//  Created by Nazri Hussein on 4/9/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit

class LessonTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var tickImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
