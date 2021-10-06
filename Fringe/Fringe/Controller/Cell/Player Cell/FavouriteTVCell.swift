//
//  FavouriteTVCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 12/08/21.
//

import UIKit
import SDWebImage
import Toucan

class FavouriteTVCell: UITableViewCell {

    @IBOutlet weak var lblGolfAddress: FGLightLabel!
    @IBOutlet weak var lblGolfName: FGSemiboldLabel!
    @IBOutlet weak var imgGolf: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(favouriteData : FavoriteListing) {
        imgGolf.sd_addActivityIndicator()
        imgGolf.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        imgGolf.sd_showActivityIndicatorView()
        if favouriteData.golfImages?.count ?? 0 > 0{
            if let image = favouriteData.golfImages?[0], image.isEmpty == false {
                let imgURL = URL(string: image)
                imgGolf.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                    if let serverImage = serverImage {
                        self.imgGolf.image = Toucan.init(image: serverImage).resizeByCropping(FGSettings.profileImageSize).maskWithRoundedRect(cornerRadius: 0, borderWidth: FGSettings.profileBorderWidth, borderColor: .clear).image
                    }
                    self.imgGolf.sd_removeActivityIndicator()
                }
            } else {
                self.imgGolf.sd_removeActivityIndicator()
            }
        } else {
            self.imgGolf.sd_removeActivityIndicator()
            imgGolf.image = UIImage(named: FGImageName.imgPlaceHolder)
        }
        lblGolfName.text = favouriteData.golfCourseName ?? String()
        lblGolfAddress.text = favouriteData.location ?? String()
    }
}
