//
//  FringePendingCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 13/08/21.
//

import UIKit

class FringePendingCell: UITableViewCell {

    @IBOutlet weak var btnCancelation: FGActiveButton!
    @IBOutlet weak var golfClubNameLbl: FGMediumLabel!
    @IBOutlet weak var dateLbl: FGRegularLabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnMoreInfo: FGActiveButton!
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
