//
//  HomeListingTBCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 25/08/21.
//

import UIKit

class HomeListingTBCell: UITableViewCell {
    
    @IBOutlet weak var lblRate: FGMediumLabel!
    @IBOutlet weak var lblRating: FGRegularLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblAddress: FGRegularLabel!
    @IBOutlet weak var lblGolfClubName: FGSemiboldLabel!
    @IBOutlet weak var mainImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
