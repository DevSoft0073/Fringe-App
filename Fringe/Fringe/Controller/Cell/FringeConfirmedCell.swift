//
//  FringeConfirmedCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 16/08/21.
//

import UIKit

class FringeConfirmedCell: UITableViewCell {

    @IBOutlet weak var golfClubNameLbl: FGMediumLabel!
    @IBOutlet weak var dateLbl: FGRegularLabel!
    @IBOutlet weak var btnSeeMore: FGActiveButton!
    @IBOutlet weak var nameLbl: FGSemiboldLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
