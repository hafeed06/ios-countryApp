//
//  CoutryViewCell.swift
//  CountryCustom
//
//  Created by user on 06/02/2022.
//

import UIKit

class CoutryViewCell: UITableViewCell {
    
    @IBOutlet var alphacode : UILabel!
    @IBOutlet var countryname : UILabel!
    @IBOutlet var flagimg : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
