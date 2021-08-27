//
//  DetailsScreenVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 23/08/21.
//
import UIKit
import Foundation

class DetailsScreenVC : BaseVC {
    
    @IBOutlet weak var imgGolfClub: UIImageView!
    @IBOutlet weak var lblDetails: FGRegularLabel!
    @IBOutlet weak var lblRate: FGMediumLabel!
    @IBOutlet weak var lblRating: FGRegularLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblGolfClubAddress: FGMediumLabel!
    @IBOutlet weak var lblGolfClubName: FGSemiboldLabel!
    @IBOutlet weak var btnHeart: UIButton!
    
    var check = true
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnHeart(_ sender: Any) {
        check = !check
        
        if check == true {
            btnHeart.setImage(UIImage(named: FGImageName.iconWhiteHeart), for: .normal)
                } else {
                    btnHeart.setImage(UIImage(named: ""), for: .normal)
                }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
        
    }
    
    @IBAction func btnChat(_ sender: Any) {
    }
    
    @IBAction func btnCheckAvailability(_ sender: Any) {
        let controller = NavigationManager.shared.checkAvailabilityVC
        push(controller: controller)
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenu = false
    }
    
    //------------------------------------------------------
}
