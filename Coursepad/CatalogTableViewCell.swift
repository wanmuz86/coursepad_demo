//
//  CatalogTableViewCell.swift
//  Coursepad
//
//  Created by Nazri Hussein on 4/2/17.
//  Copyright © 2017 iItrain Asia. All rights reserved.
//

import UIKit

class CatalogTableViewCell: UITableViewCell {
    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var pubLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
