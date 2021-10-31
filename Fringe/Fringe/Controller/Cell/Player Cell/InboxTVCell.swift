//
//  InboxTVCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 02/09/21.
//

import UIKit
import Toucan
import SDWebImage

class InboxTVCell: UITableViewCell {

    @IBOutlet weak var lblCount: FGMediumLabel!
    @IBOutlet weak var lblDate: FGMediumLabel!
    @IBOutlet weak var lblAddress: FGRegularLabel!
    @IBOutlet weak var lblName: FGSemiboldLabel!
    @IBOutlet weak var mainSecondImg: UIImageView!
    @IBOutlet weak var mainFirstImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        mainFirstImg.circle()
        mainSecondImg.circle()
    }
    
    func setup(messageGroup: GetAllChatUsers) {
        
        //own image
        mainFirstImg.sd_addActivityIndicator()
        mainFirstImg.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        mainFirstImg.sd_showActivityIndicatorView()
        mainFirstImg.image = getPlaceholderImage()
        if let image = messageGroup.image, image.isEmpty == false {
            let imgURL = URL(string: image)
            mainFirstImg.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                if let serverImage = serverImage {
                    self.mainFirstImg.image = Toucan.init(image: serverImage).resizeByCropping(FGSettings.profileImageSize).maskWithRoundedRect(cornerRadius: FGSettings.profileImageSize.width/2, borderWidth: FGSettings.profileBorderWidth, borderColor: .clear).image
                }
                self.mainFirstImg.sd_removeActivityIndicator()
            }
        } else {
            self.mainFirstImg.sd_removeActivityIndicator()
        }
        if messageGroup.image?.isEmpty == true{
            self.mainFirstImg.image = UIImage(named: "icon_placeholder")
        }

        lblName.text = messageGroup.name
        
        let dateFromUnix = DateTimeManager.shared.dateFrom(unix: messageGroup.unixDate)
        
        if DateTimeManager.shared.isToday(dateFromUnix)  {
            lblDate.text = DateTimeManager.shared.dateFrom(unix: messageGroup.unixDate, inFormate: TimeFormate.HH_MM)
        } else if DateTimeManager.shared.isYesterday(dateFromUnix) {
            let dateString = String(format: "Yesterday %@", DateTimeManager.shared.dateFrom(unix: messageGroup.unixDate, inFormate: TimeFormate.HH_MM))
            lblDate.text = dateString
        } else {
            lblDate.text = DateTimeManager.shared.dateFrom(unix: messageGroup.unixDate, inFormate: DateFormate.MMM_DD_COM_yyyy_HH_MM)
        }
        lblCount.setRounded()
        if messageGroup.messageCount == "0" {
            lblCount.isHidden = true
        } else {
            lblCount.isHidden = false
            lblCount.text = messageGroup.messageCount ?? ""
        }
    }
}
