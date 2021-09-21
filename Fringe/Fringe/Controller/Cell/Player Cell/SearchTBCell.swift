//
//  SearchTBCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 24/08/21.
//

import UIKit

class SearchTBCell: UITableViewCell {


    @IBOutlet weak var lblRate: FGMediumLabel!
    @IBOutlet weak var lblRating: FGRegularLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblAddress: FGRegularLabel!
    @IBOutlet weak var lblName: FGSemiboldLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setup(homeData : HomeModal) {
        
//        //image
//        mainImg.sd_addActivityIndicator()
//        mainImg.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
//        mainImg.sd_showActivityIndicatorView()
//        mainImg.image = getPlaceholderImage()
//        if let image = homeData.image, image.isEmpty == false {
//            let imgURL = URL(string: image)
//            mainImg.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
//                if let serverImage = serverImage {
//                    self.mainImg.image = Toucan.init(image: serverImage).resizeByCropping(FGSettings.profileImageSize).maskWithRoundedRect(cornerRadius: 0, borderWidth: FGSettings.profileBorderWidth, borderColor: .clear).image
//                }
//                self.mainImg.sd_removeActivityIndicator()
//            }
//        } else {
//            self.mainImg.sd_removeActivityIndicator()
//        }
//
        lblName.text = homeData.golfCourseName
        lblAddress.text = homeData.location
        lblRate.text = homeData.price
        lblRating.text = homeData.rating
        ratingView.rating = Double(homeData.rating ?? String()) ?? Double()
    }
    
}
