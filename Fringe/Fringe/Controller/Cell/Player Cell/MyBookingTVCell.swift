//
//  MyBookingTVCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 19/08/21.
//

import UIKit
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
        if let image = bookingData.image, image.isEmpty == false {
            let imgURL = URL(string: image)
            imgMain.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                self.imgMain.sd_removeActivityIndicator()
            }
        } else {
            self.imgMain.sd_removeActivityIndicator()
        }
//
        lblName.text = bookingData.golfCourseName
        lblAddress.text = bookingData.location
        lblRate.text = bookingData.price
//        lblRating.text = bookingData.
//        ratingView.rating = Double(homeData.rating ?? String()) ?? Double()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imgMain.roundCornersLeft( [.topLeft, .bottomLeft],radius: 16)
    }
    
}
