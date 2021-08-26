//
//  SegmentView.swift
//  SessionControl
//
//  Created by Dharmesh Avaiya on 3/31/21.
//  Copyright © 2021 dharmesh. All rights reserved.
//

import UIKit

protocol SegmentViewDelegate {
    
    func segment(view: SegmentView, didChange flag: Bool)
}

class SegmentView: UIView {
    
    
    @IBOutlet weak var separater: UIView!
    @IBOutlet weak var btn: FGRegularButton!
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                separater.backgroundColor = FGColor.appGreen
                btn.setTitleColor(FGColor.appGreen, for: UIControl.State.normal)
            } else {
                separater.backgroundColor = FGColor.appBorder
                btn.setTitleColor(FGColor.appBlack, for: UIControl.State.normal)
            }
        }
    }
    
    var delegate: SegmentViewDelegate?
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    
    @IBAction func btnTap(_ sender: Any) {
        if isSelected {
            return
        }
        isSelected.toggle()
        delegate?.segment(view: self, didChange: true)
    }
    
    //------------------------------------------------------
}
