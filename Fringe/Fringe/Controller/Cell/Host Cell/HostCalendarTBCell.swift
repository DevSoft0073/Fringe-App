//
//  HostCalendarTBCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 31/08/21.
//

import UIKit

class HostCalendarTBCell: UITableViewCell {

    @IBOutlet weak var lblAddress: FGMediumLabel!
    @IBOutlet weak var lblDate: FGRegularLabel!
    @IBOutlet weak var lblGolfClubName: FGSemiboldLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setup(bookingData : CheckModal) {
        
        lblGolfClubName.text = bookingData.golfCourseName
        lblAddress.text = bookingData.location
//        lblRating.text = bookingData.ra
        lblDate.text = bookingData.date
    }
    
    
}
