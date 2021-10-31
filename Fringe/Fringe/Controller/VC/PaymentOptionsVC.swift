//
//  PaymentOptionsVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 08/09/21.
//

import UIKit
import PayPalCheckout
import Foundation

class PaymentOptionsVC : BaseVC, UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var tblPyament: UITableView!
    @IBOutlet weak var lblTotal: FGMediumLabel!
    
    var totalGuest = String()
    var totalAmmount = String()
    var detailsData: RequestListingModal?
    struct AddPaymentItems {
        static let creditCard = LocalizableConstants.Controller.AddPaymentMethod.creditDebitCard
        static let creditCardIcon = FGImageName.iconCreditCardPayment
        static let payPal = LocalizableConstants.Controller.AddPaymentMethod.payPalCard
        static let payPalIcon = FGImageName.iconPayPayment
        static let applePay = LocalizableConstants.Controller.AddPaymentMethod.appleCard
        static let applePayIcon = FGImageName.iconApplePayment
    }
    
    var itemNormal: [ [String:String] ] {
        return [
            ["name": AddPaymentItems.creditCard, "image": AddPaymentItems.creditCardIcon],
//            ["name": AddPaymentItems.payPal, "image": AddPaymentItems.payPalIcon],
//            ["name": AddPaymentItems.applePay, "image": AddPaymentItems.applePayIcon],
            
        ]
    }
    var items: [ [String: String] ] {
        return itemNormal
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
    
    //MARK: Customs
    
    func setup() {
        tblPyament.delegate = self
        tblPyament.dataSource = self
        tblPyament.separatorStyle = .none
        lblTotal.text = "Total Amount Payable \(totalAmmount)"
        let identifier = String(describing: AddPaymentTVCell.self)
        
        let nibRequestCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblPyament.register(nibRequestCell, forCellReuseIdentifier: identifier)
        
    }
    func updateUI() {

        tblPyament.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let name = item["name"]
        let image = item["image"]!
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPaymentTVCell", for: indexPath) as! AddPaymentTVCell
        cell.setup(image: image, name: name?.localized())
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if indexPath.row == 0 {
//
//            let controller = NavigationManager.shared.paymentMethodVC
//            controller.detailsData = detailsData
//            controller.totalGuest = totalGuest
//            controller.totalAmmount = totalAmmount
//            controller.isComesFrom = false
//            controller.comesFrom = "1"
//            push(controller: controller)
//
//        } else if indexPath.row == 1 {
//
//            triggerPayPalCheckout()
//
//        } else {
//
//        }
        
        let item = items[indexPath.row]
        let name = item["name"]
        
        if name == AddPaymentItems.creditCard {
            
            let controller = NavigationManager.shared.paymentMethodVC
            controller.detailsData = detailsData
            controller.totalGuest = totalGuest
            controller.totalAmmount = totalAmmount
            controller.isComesFrom = false
            controller.comesFrom = "1"
            push(controller: controller)
            
        } else if name == AddPaymentItems.applePay {
            
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: "Comming soon....") {
            }
            
        } else if name == AddPaymentItems.payPal {
            
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: "Comming soon....") {
            }
            
        }
    }
    
//    func triggerPayPalCheckout() {
//            Checkout.start(
//                createOrder: { createOrderAction in
//
//                    let amount = PurchaseUnit.Amount(currencyCode: .usd, value: "10.00")
//                    let purchaseUnit = PurchaseUnit(amount: amount)
//                    let order = OrderRequest(intent: .authorize, purchaseUnits: [purchaseUnit])
//
//                    createOrderAction.create(order: order)
//
//                }, onApprove: { approval in
//
//                    approval.actions.authorize { (response, error) in
//                        print(response?.data.orderData)
//                    }
//                }, onCancel: {
//
//                    // Optionally use this closure to respond to the user canceling the paysheet
//                }, onError: { error in
//                  print(error)
//                    // Optionally use this closure to respond to the user experiencing an error in
//                    // the payment experience
//                }
//            )
//        }
//
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
        
        NavigationManager.shared.isEnabledBottomMenu = false
    }
    
    //------------------------------------------------------
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
