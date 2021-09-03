//
//  BookingDetailsVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 21/08/21.
//

import UIKit
import Foundation

class BookingDetailsVC : BaseVC {
    
    @IBOutlet weak var lblName: FGSemiboldLabel!
    @IBOutlet weak var lblAddress: FGMediumLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblRating: FGRegularLabel!
    @IBOutlet weak var lblRate: FGMediumLabel!
    @IBOutlet weak var lblDate: FGRegularLabel!
        
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
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        let controller = NavigationManager.shared.bookingDetailsRatingVC
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
    }
    
    //------------------------------------------------------
}

