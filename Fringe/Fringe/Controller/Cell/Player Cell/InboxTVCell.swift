//
//  InboxTVCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 02/09/21.
//

import UIKit

class InboxTVCell: UITableViewCell {

    @IBOutlet weak var lblDate: FGMediumLabel!
    @IBOutlet weak var lblAddress: FGRegularLabel!
    @IBOutlet weak var lblName: FGSemiboldLabel!
    @IBOutlet weak var mainSecondImg: UIImageView!
    @IBOutlet weak var mainFirstImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        mainFirstImg.circle()
        mainSecondImg.circle()
    }
    
}
