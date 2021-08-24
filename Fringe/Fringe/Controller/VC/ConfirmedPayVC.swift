//
//  ConfirmedPayVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 24/08/21.
//

import UIKit
import Foundation

class ConfirmedPayVC : BaseVC {
    
   
    @IBOutlet weak var lblOccupancyTax: FGMediumLabel!
    @IBOutlet weak var lblTotalPrice: FGMediumLabel!
    @IBOutlet weak var lblServiceTax: FGMediumLabel!
    @IBOutlet weak var lblGolfclubPrice: FGMediumLabel!
    @IBOutlet weak var lblGuests: FGRegularLabel!
    @IBOutlet weak var lblDate: FGRegularLabel!
    @IBOutlet weak var lblRating: FGRegularLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblAddress: FGRegularLabel!
    @IBOutlet weak var lblName: FGSemiboldLabel!
    @IBOutlet weak var imgMain: UIImageView!
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
    
    @IBAction func btnAddPayment(_ sender: Any) {
        let controller = NavigationManager.shared.searchVC
        push(controller: controller)
    }
    @IBAction func btnEditGuests(_ sender: Any) {
    }
    @IBAction func btnEditDate(_ sender: Any) {
    }
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
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
