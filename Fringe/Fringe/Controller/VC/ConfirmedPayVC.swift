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
    @IBOutlet weak var lblGuest: UILabel!
    
    var isUpdate:(()->Void)?
    var detailsData: RequestListingModal?
    var isSelected : Bool = true
    var addGuestVal: Int = 2 {
        didSet {
            lblGuest.text = "\(addGuestVal)"
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setupData() {
        lblGuests.text = "\(addGuestVal)"
        lblGolfclubPrice.text = "$\(detailsData?.golfPrice ?? String())"
        guard let price = Int(detailsData?.golfPrice ?? String()) else { return }
        let totalPrice = addGuestVal * price
        var total = serviceCalculation(price: totalPrice)
        total += Double(totalPrice)
        lblTotalPrice.text = "$\(total)"
    }
    
    func serviceCalculation(price:Int)->Double{
        let priceDouble = Double(price)
        let serviceFee =  priceDouble * 0.029
        lblServiceTax.text = "\(serviceFee)"
        let occupancyTax = serviceFee + 0.3
        lblOccupancyTax.text = "\(occupancyTax)"
        return occupancyTax.rounded(toPlaces: 2)
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnAddPayment(_ sender: Any) {
        let controller = NavigationManager.shared.paymentOptionsVC
        controller.totalGuest = lblGuest.text ?? String()
        controller.detailsData = detailsData
        controller.totalAmmount = lblTotalPrice.text ?? String()
        push(controller: controller)
    }
    
    @IBAction func btnEditGuests(_ sender: Any) {
        let controller = NavigationManager.shared.addGuestVC
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: true) {
        }
    }
    
    @IBAction func btnPlus(_ sender: Any) {
        if lblGuest.text ?? "" >= "4"{
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterAddGuestLimit)
        }else if lblGuest.text ?? "" >= "1" {
            addGuestVal  = addGuestVal+1
        }
        lblGuest.text = "\(addGuestVal)"
        self.setupData()
    }
    
    @IBAction func btnMinus(_ sender: Any) {
        if lblGuest.text == "1" {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterRemoveGuestLimit)
            
        }else if lblGuest.text ?? "" >= "1" {
            addGuestVal  = addGuestVal-1
        }
        lblGuest.text = "\(addGuestVal)"
        self.setupData()
    }
    
    @IBAction func btnEditDate(_ sender: Any) {
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.popWithHandler {
            self.isUpdate?()
        }
    }
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenu = false
    }
    
    //------------------------------------------------------
}
