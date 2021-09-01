//
//  HostPendingCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 30/08/21.
//

import UIKit

class HostPendingCell: UITableViewCell {

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnMoreInfo: FGActiveButton!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var btnReject: FGActiveWhiteButton!
    @IBOutlet weak var btnAccept: FGActiveButton!
    @IBOutlet weak var golfClubNameLbl: FGMediumLabel!
    @IBOutlet weak var dateLbl: FGRegularLabel!
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
