//
//  ProfileSwitchCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 17/08/21.
//

import UIKit

class ProfileSwitchCell: UITableViewCell {
    
    @IBOutlet weak var lblName: FGMediumLabel!
    @IBOutlet weak var switchPermission: UISwitch!
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup(name: String?) {
        
        lblName.text = name
    }
    
    
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func valueDidChanged(_ sender: UISwitch) {
        
    }
    //------------------------------------------------------
    
    //MARK: Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        accessoryType = .none
        selectionStyle = .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
