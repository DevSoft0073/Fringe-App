//
//  NotificationTVCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 12/08/21.
//

import UIKit
import Toucan
import SDWebImage

class NotificationTVCell: UITableViewCell {

    @IBOutlet weak var lblData: FGRegularLabel!
    @IBOutlet weak var lblName: FGSemiboldLabel!
    @IBOutlet weak var imgGolfer: UIImageView!
    
    func setUp(notificationData : NotificationModal)  {
        
        //image
        imgGolfer.sd_addActivityIndicator()
        imgGolfer.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        imgGolfer.sd_showActivityIndicatorView()
        if let image = notificationData.image, image.isEmpty == false {
            let imgURL = URL(string: image)
            imgGolfer.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                if let serverImage = serverImage {
                    self.imgGolfer.image = Toucan.init(image: serverImage).resizeByCropping(CGSize.init(width: self.imgGolfer.bounds.width * 2, height: self.imgGolfer.bounds.height * 2)).image
                }
                self.imgGolfer.sd_removeActivityIndicator()
            }
        } else {
            self.imgGolfer.sd_removeActivityIndicator()
        }
        if notificationData.image == ""{
            self.imgGolfer.image = UIImage(named: "placeholder-image")
        }
        lblName.text = notificationData.message
        lblData.text = notificationData.createdAt
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        imgGolfer.circle()
    }
}
