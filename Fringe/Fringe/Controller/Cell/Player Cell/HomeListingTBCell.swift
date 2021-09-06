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
        if let image = homeData.image, image.isEmpty == false {
            let imgURL = URL(string: image)
            mainImg.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                self.mainImg.sd_removeActivityIndicator()
            }
        } else {
            self.mainImg.sd_removeActivityIndicator()
        }
        
        lblGolfClubName.text = homeData.golfCourseName
        lblAddress.text = homeData.location
        lblPrice.text = homeData.price
        lblRating.text = homeData.rating
        ratingView.rating = Double(homeData.rating ?? String()) ?? Double()
    }
}
