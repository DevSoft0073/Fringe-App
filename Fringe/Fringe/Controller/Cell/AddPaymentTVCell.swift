//
//  AddPaymentTVCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 19/08/21.
//

import UIKit

class AddPaymentTVCell: UITableViewCell {
    
    @IBOutlet weak var imgPayment: UIImageView!
    @IBOutlet weak var lblPayment: FGRegularLabel!
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup(image: String, name: String?) {
        
        imgPayment.image = UIImage(named: image)
        lblPayment.text = name
        
        //        if name == ProfileVC.ProfileItems.logout {
        //            isDisclosureIndicatorVisible = false
        //        } else {
        //            isDisclosureIndicatorVisible = true
        //        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
