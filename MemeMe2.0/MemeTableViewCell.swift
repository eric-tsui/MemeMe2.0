//
//  MemeTableViewCell.swift
//  MemeMe2.0
//
//  Created by EricTsui on 28/11/16.
//  Copyright © 2016 EricTsui. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let space:CGFloat = 3.0
        //let dimension = (UIScreen.main   view.frame.size.width - (2*space))/3.0
        let dimension = (UIScreen.main.bounds.width - (2*space))/3.0
        self.imageView?.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
    }

}
