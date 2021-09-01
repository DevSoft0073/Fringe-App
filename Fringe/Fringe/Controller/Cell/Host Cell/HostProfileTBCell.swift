//
//  HostProfileTBCell.swift
//  Fringe
//
//  Created by Dharmani Apps on 31/08/21.
//

import UIKit

class HostProfileTBCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: FGMediumLabel!
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup(image: String, name: String?) {
        
        imgIcon.image = UIImage(named: image)
        lblName.text = name
        
    }
    
    func setupForHostProfile(image: String, name: String?) {
        
        imgIcon.image = UIImage(named: image)
        lblName.text = name
    }
    
    func setupForSupportItems(image: String, name: String?) {
        
        imgIcon.image = UIImage(named: image)
        lblName.text = name
        
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
