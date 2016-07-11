//
//  TopRateTableViewCell.swift
//  Flicks
//
//  Created by admin on 7/10/16.
//  Copyright © 2016 nguyen thanh thuc. All rights reserved.
//

import UIKit

class TopRateTableViewCell: UITableViewCell {

    @IBOutlet weak var topRateImage: UIImageView!
    
    @IBOutlet weak var filmNameLabel: UILabel!
    
    @IBOutlet weak var descriptionShortLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
