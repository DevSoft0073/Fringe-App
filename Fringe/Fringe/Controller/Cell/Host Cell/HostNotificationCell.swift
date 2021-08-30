//
//  HostNotificationCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 30/08/21.
//

import UIKit

class HostNotificationCell: UITableViewCell {

    @IBOutlet weak var lblName: FGSemiboldLabel!
    @IBOutlet weak var lblData: FGRegularLabel!
    @IBOutlet weak var imgGolfer: UIImageView!
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
    
        imgGolfer.circle()
    }
    
}
