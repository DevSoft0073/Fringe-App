//
//  LeftCell.swift
//  Fringe
//
//  Created by MyMac on 10/4/21.
//

import UIKit

class LeftCell: UITableViewCell {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var txtMsgView: UITextView!
    @IBOutlet weak var imgProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageView.layer.cornerRadius = 12
        if #available(iOS 11, *) {
            messageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner ,.layerMaxXMaxYCorner]
        }
    }
    
}
