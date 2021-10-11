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
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setup(bookingData : CheckModal) {
        ratingView.isUserInteractionEnabled = false
        lblName.text = bookingData.golfCourseName
        lblGuestDetails.text = bookingData.checkModalDescription
        lblRating.text = bookingData.rating
        lblAddress.text = bookingData.location
        lblRate.text = "$\(bookingData.price ?? String())"
        ratingView.rating = Double(bookingData.rating ?? String()) ?? Double()
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        selectionStyle = .none
    }
    
    //------------------------------------------------------

}
