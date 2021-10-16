//
//  HostPendingCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 30/08/21.
//

import UIKit

class HostPendingCell: UITableViewCell {

    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var lblMemebr: UILabel!
    @IBOutlet weak var lblProf: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
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
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setup(bookingData : HostlistingModal) {
        
        nameLbl.text = bookingData.userDetails?.userName
        golfClubNameLbl.text = "Address: \(bookingData.location ?? String())"
        lblEmail.text = "Email:\(bookingData.userDetails?.email ?? String())"
        lblMobile.text = "Mobile No. : \(bookingData.userDetails?.mobileNo ?? String())"
        lblMemebr.text = "Member Course: \(bookingData.userDetails?.memberCourse ?? String())"
        lblProf.text = "Profession: \(bookingData.userDetails?.profession ?? String())"
        dateLbl.text = bookingData.date
        
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        selectionStyle = .none
    }
    
}
