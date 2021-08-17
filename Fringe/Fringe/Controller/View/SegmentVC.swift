//
//  SegmentVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 16/08/21.
//

import UIKit

protocol SegmentViewDelegates {
    
    func segment(view: SegmentView, didChange flag: Bool)
}


class SegmentVC: UIView {
    
    
    var delegate: SegmentViewDelegates?
    
    @IBAction func btnTap(_ sender: Any) {
        
    }
    
}
