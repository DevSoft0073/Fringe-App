//
//  RightCell.swift
//  Fringe
//
//  Created by MyMac on 10/4/21.
//

import UIKit

class RightCell: UITableViewCell {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtMsgView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageView.layer.cornerRadius = 12
        if #available(iOS 11, *) {
            messageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner ,.layerMinXMinYCorner]
        }
    }
    
}
