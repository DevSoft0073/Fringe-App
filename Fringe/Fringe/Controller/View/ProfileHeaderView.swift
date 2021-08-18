//
//  ProfileHeaderView.swift
//  Fringe
//
//  Created by Dharmani Apps on 16/08/21.
//

import UIKit
import Toucan
import SDWebImage

class ProfileHeaderView: UIView {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: FGMediumLabel!
    @IBOutlet weak var lblEmail: FGRegularLabel!
    @IBOutlet weak var btnEdit: FGActiveButtonEdit!
    
    //------------------------------------------------------
    
    //MARK: Custom
    
    func setupData(_ currentUser: UserModal?) {

        //image
        imgProfile.sd_addActivityIndicator()
        imgProfile.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        imgProfile.sd_showActivityIndicatorView()
//        imgProfile.image = getPlaceholderImage()
        if let image = currentUser?.image, image.isEmpty == false {
            let imgURL = URL(string: image)
            imgProfile.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
//                if let serverImage = serverImage {
//                   self.imgProfile.image = Toucan.init(image: serverImage).resizeByCropping(SCSettings.profileImageSize).maskWithRoundedRect(cornerRadius: SCSettings.profileImageSize.width/2, borderWidth: SCSettings.profileBorderWidth, borderColor: SCColor.appOrange).image
                }
//                self.imgProfile.sd_removeActivityIndicator()
//            }
//        } else {
//            self.imgProfile.sd_removeActivityIndicator()
//        }
//
//        //firstname
//        lblName.text = currentUser?.fullName
//
//        //firstname
//        lblName.text = currentUser?.name
//
//        //email
//        lblEmail.text = currentUser?.email
//
    }
    }
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnEdit(_ sender: Any) {
    }
}
