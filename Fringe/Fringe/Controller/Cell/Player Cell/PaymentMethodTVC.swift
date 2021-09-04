//
//  PaymentMethodTVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 03/09/21.
//

import UIKit

class PaymentMethodTVC: UITableViewCell {

    @IBOutlet weak var cardDetails: FGRegularLabel!
    @IBOutlet weak var nameLbl: FGSemiboldLabel!
    @IBOutlet weak var iconImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
