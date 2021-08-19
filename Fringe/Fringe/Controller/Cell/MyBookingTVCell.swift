//
//  MyBookingTVCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 19/08/21.
//

import UIKit

class MyBookingTVCell: UITableViewCell {

    @IBOutlet weak var lblName: FGSemiboldLabel!
    @IBOutlet weak var lblAddress: FGRegularLabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblRate: FGMediumLabel!
    @IBOutlet weak var lblRating: FGRegularLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
