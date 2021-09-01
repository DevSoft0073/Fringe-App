//
//  HostCalendarTBCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 31/08/21.
//

import UIKit

class HostCalendarTBCell: UITableViewCell {

    @IBOutlet weak var lblAddress: FGMediumLabel!
    @IBOutlet weak var lblDate: FGRegularLabel!
    @IBOutlet weak var lblGolfClubName: FGSemiboldLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
