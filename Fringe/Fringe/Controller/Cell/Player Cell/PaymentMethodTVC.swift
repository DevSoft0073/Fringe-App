//
//  PaymentMethodTVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 03/09/21.
//

import UIKit

class PaymentMethodTVC: UITableViewCell {

    @IBOutlet weak var selectUnselectImg: UIImageView!
    @IBOutlet weak var cardDetails: FGRegularLabel!
    @IBOutlet weak var nameLbl: FGSemiboldLabel!
    @IBOutlet weak var iconImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setup(cardData : PaymentDataModel , comesFromm : String) {
        cardDetails.text = "Card Number Ending with \(cardData.last4 ?? "")"
        nameLbl.text = cardData.cardHolderName
        if comesFromm == "0" {
            selectUnselectImg.isHidden = true
        } else {
            selectUnselectImg.isHidden = false
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
    }
}
