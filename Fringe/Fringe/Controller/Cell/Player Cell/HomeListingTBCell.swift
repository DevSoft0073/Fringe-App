//
//  HomeListingTBCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 25/08/21.
//

import UIKit
import SDWebImage
import Toucan

class HomeListingTBCell: UITableViewCell {
    
    @IBOutlet weak var lblPrice: FGMediumLabel!
    @IBOutlet weak var lblRating: FGRegularLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblAddress: FGRegularLabel!
    @IBOutlet weak var lblGolfClubName: FGSemiboldLabel!
    @IBOutlet weak var mainImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setup(homeData : HomeModal) {
        
        //image
        mainImg.sd_addActivityIndicator()
        mainImg.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        mainImg.sd_showActivityIndicatorView()
        mainImg.image = getPlaceholderImage()
        if homeData.golfImages?.count ?? 0 > 0{
            if let image = homeData.golfImages?[0], image.isEmpty == false {
                let imgURL = URL(string: image)
                mainImg.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                    if let serverImage = serverImage {
                        self.mainImg.image = Toucan.init(image: serverImage).resizeByCropping(FGSettings.profileImageSize).maskWithRoundedRect(cornerRadius: 0, borderWidth: FGSettings.profileBorderWidth, borderColor: .clear).image
                    }
                    self.mainImg.sd_removeActivityIndicator()
                }
            } else {
                self.mainImg.sd_removeActivityIndicator()
            }
        } else {
            self.mainImg.sd_removeActivityIndicator()
            mainImg.image = UIImage(named: FGImageName.imgPlaceHolder)
        }
        
        lblGolfClubName.text = homeData.golfCourseName
        lblAddress.text = homeData.location
        lblPrice.text = homeData.price
        lblRating.text = homeData.rating
        ratingView.rating = Double(homeData.rating ?? String()) ?? Double()
    }
}
