//
//  FavouriteTVCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 12/08/21.
//

import UIKit

class FavouriteTVCell: UITableViewCell {
    
    @IBOutlet weak var lblGolfAddress: FGLightLabel!
    @IBOutlet weak var lblGolfName: FGSemiboldLabel!
    @IBOutlet weak var imgGolf: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
