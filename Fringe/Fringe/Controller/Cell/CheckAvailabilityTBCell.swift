//
//  CheckAvailabilityTBCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 21/08/21.
//

import UIKit

class CheckAvailabilityTBCell: UITableViewCell {

    @IBOutlet weak var lblRate: FGMediumLabel!
    
    @IBOutlet weak var lblGuestDetails: FGMediumLabel!
    @IBOutlet weak var lblRating: FGRegularLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblName: FGSemiboldLabel!
    @IBOutlet weak var lblAddress: FGRegularLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
