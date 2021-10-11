//
//  FringeConfirmedCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 16/08/21.
//

import UIKit

class FringeConfirmedCell: UITableViewCell {

    @IBOutlet weak var btnRefundRequest: FGActiveButton!
    @IBOutlet weak var refundRequestView: UIView!
    @IBOutlet weak var golfClubNameLbl: FGMediumLabel!
    @IBOutlet weak var dateLbl: FGRegularLabel!
    @IBOutlet weak var btnPay: FGActiveButton!
    @IBOutlet weak var nameLbl: FGSemiboldLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //------------------------------------------------------
    
    //MARK: Custome
    
    func setup(bookingData : RequestListingModal) {
        
        nameLbl.text = bookingData.golfCourseName
        golfClubNameLbl.text = bookingData.requestListingModalDescription
        dateLbl.text = bookingData.date
        dateLbl.text = bookingData.date
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        selectionStyle = .none
    }
    
    //------------------------------------------------------
    
}
