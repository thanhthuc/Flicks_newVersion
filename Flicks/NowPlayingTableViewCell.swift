//
//  NowPlayingTableViewCell.swift
//  Flicks
//
//  Created by admin on 7/10/16.
//  Copyright © 2016 nguyen thanh thuc. All rights reserved.
//

import UIKit

class NowPlayingTableViewCell: UITableViewCell {

    @IBOutlet weak var nowPlayingImage: UIImageView!
    
    @IBOutlet weak var filmNameLable: UILabel!
    
    @IBOutlet weak var descriptionShortLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
