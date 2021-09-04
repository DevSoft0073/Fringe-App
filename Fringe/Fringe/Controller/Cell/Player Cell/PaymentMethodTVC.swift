//
//  PaymentMethodTVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 03/09/21.
//

import UIKit

class PaymentMethodTVC: UITableViewCell {

    @IBOutlet weak var checkUncheckBtn: UIButton!
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
    
    func setup(details: String , name : String) {
        cardDetails.text = details
        nameLbl.text = name
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        selectionStyle = .none
    }
    
    //------------------------------------------------------

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
