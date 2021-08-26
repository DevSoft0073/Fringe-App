//
//  PaymentOptionsTBCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 25/08/21.
//

import UIKit

class PaymentOptionsTBCell: UITableViewCell {
    
    @IBOutlet weak var lblPayment: FGRegularLabel!
    @IBOutlet weak var imgPayment: UIImageView!
    
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
