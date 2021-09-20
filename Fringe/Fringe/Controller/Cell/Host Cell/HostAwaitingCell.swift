//
//  HostAwaitingCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 30/08/21.
//

import UIKit

class HostAwaitingCell: UITableViewCell {

    @IBOutlet weak var golfClubNameLbl: FGMediumLabel!
    @IBOutlet weak var dateLbl: FGRegularLabel!
    @IBOutlet weak var nameLbl: FGSemiboldLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //------------------------------------------------------
    
    //MARK: Custome
    
    func setup(bookingData : PlayerRequestModal) {
        
        nameLbl.text = bookingData.golfCourseName
        golfClubNameLbl.text = bookingData.golfCourseName
        dateLbl.text = bookingData.date
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        selectionStyle = .none
    }
    
}
