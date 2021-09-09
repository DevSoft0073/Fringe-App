//
//  FringePendingCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 13/08/21.
//

import UIKit

class FringePendingCell: UITableViewCell {

    @IBOutlet weak var cancelView: UIView!
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
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setup(bookingData : RequestListingModal) {
        
        nameLbl.text = bookingData.golfCourseName
        golfClubNameLbl.text = bookingData.golfCourseName
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
