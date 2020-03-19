//
//  PresidentCell.swift
//  Presidents
//
//  Created by Victor on 11/16/16.
//  Copyright © 2016 Victor. All rights reserved.
//

import UIKit

class PresidentCell: UITableViewCell {
    
    @IBOutlet weak var presidentImageView: UIImageView! //Labels for master scene
    @IBOutlet weak var presidentNameLabel: UILabel!
    @IBOutlet weak var polPartyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
