//
//  DetailsViewCell.swift
//  CountryCustom
//
//  Created by user on 07/02/2022.
//

import UIKit

class DetailsViewCell: UITableViewCell {

    
    @IBOutlet weak var detailsContent: UILabel!
    @IBOutlet weak var detailsTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
