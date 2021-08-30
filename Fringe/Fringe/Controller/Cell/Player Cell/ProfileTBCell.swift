//
//  ProfileTBCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 17/08/21.
//

import UIKit

class ProfileTBCell: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: FGMediumLabel!
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup(image: String, name: String?) {
        
        imgIcon.image = UIImage(named: image)
        lblName.text = name
        
//        if name == ProfileVC.ProfileItems.logout {
//            isDisclosureIndicatorVisible = false
//        } else {
//            isDisclosureIndicatorVisible = true
//        }
    }
    func setupForStudioProfile(image: String, name: String?) {
        
        imgIcon.image = UIImage(named: image)
        lblName.text = name
//        isDisclosureIndicatorVisible = true

//        if name == ProfileVCForStudioProfile.ProfileItems.logout {
//            isDisclosureIndicatorVisible = false
//        } else {
//            isDisclosureIndicatorVisible = true
//        }
    }
    
    func setupForSupportItems(image: String, name: String?) {
        
        imgIcon.image = UIImage(named: image)
        lblName.text = name
        
//        if name == ProfileVCForStudioProfile.ProfileItemsForSupport.logout {
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
