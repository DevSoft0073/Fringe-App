//
//  MyBookingTVCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 19/08/21.
//

import UIKit
import Toucan
import SDWebImage

class MyBookingTVCell: UITableViewCell {

    @IBOutlet weak var lblName: FGSemiboldLabel!
    @IBOutlet weak var lblAddress: FGRegularLabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblRate: FGMediumLabel!
    @IBOutlet weak var lblRating: FGRegularLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgMain.roundCornersLeft( [.topLeft, .bottomLeft],radius: 16)
        
    }
    
    func setup(bookingData : BookingModal)  {
        //image
        
        imgMain.sd_addActivityIndicator()
        imgMain.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        imgMain.sd_showActivityIndicatorView()
        imgMain.image = getPlaceholderImage()
        if bookingData.golfImages?.count ?? 0 > 0{
            if let image = bookingData.golfImages?[0], image.isEmpty == false {
                let imgURL = URL(string: image)
                imgMain.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                    if let serverImage = serverImage {
                        self.imgMain.image = Toucan.init(image: serverImage).resizeByCropping(FGSettings.profileImageSize).maskWithRoundedRect(cornerRadius: 0, borderWidth: FGSettings.profileBorderWidth, borderColor: .clear).image
                    }
                    self.imgMain.sd_removeActivityIndicator()
                }
            } else {
                self.imgMain.sd_removeActivityIndicator()
            }
        } else {
            self.imgMain.sd_removeActivityIndicator()
            imgMain.image = UIImage(named: FGImageName.imgPlaceHolder)
        }
        
        lblName.text = bookingData.golfCourseName
        lblAddress.text = bookingData.location
        lblRate.text = "$\(bookingData.price ?? String())"
        lblRating.text = bookingData.rating
        ratingView.rating = Double(bookingData.rating ?? String()) ?? Double()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imgMain.roundCornersLeft( [.topLeft, .bottomLeft],radius: 16)
    }
    
}
