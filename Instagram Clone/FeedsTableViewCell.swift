//
//  FeedsTableViewCell.swift
//  Instagram Clone
//
//  Created by Rumin on 12/6/17.
//  Copyright © 2017 Rumin. All rights reserved.
//

import UIKit

class FeedsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView_uploadedImage: UIImageView!
    @IBOutlet weak var lbl_imageDescription: UILabel!
    @IBOutlet weak var lbl_username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
