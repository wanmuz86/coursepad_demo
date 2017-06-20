//
//  CatInfoTableViewCell.swift
//  Coursepad
//
//  Created by Metech3 on 5/29/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit

class CatInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var producerLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
