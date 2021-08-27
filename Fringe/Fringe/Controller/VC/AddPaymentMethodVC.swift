//
//  AddPaymentMethodVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 19/08/21.
//

import UIKit
import Foundation

class AddPaymentMethodVC : BaseVC , UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var tblAddPayment: UITableView!
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
            ["name": AddPaymentItems.payPal, "image": AddPaymentItems.payPalIcon],
            ["name": AddPaymentItems.applePay, "image": AddPaymentItems.applePayIcon],
            
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
        tblAddPayment.delegate = self
        tblAddPayment.dataSource = self
        navigationItem.title = LocalizableConstants.Controller.Notifications.title.localized()
        
        //        let loadMoreView = KRPullLoadView()
        //        loadMoreView.delegate = self
        //        tblNotification.addPullLoadableView(loadMoreView, type: .refresh)
        
        let identifier = String(describing: AddPaymentTVCell.self)
        
        let nibRequestCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblAddPayment.register(nibRequestCell, forCellReuseIdentifier: identifier)
        
    }
    func updateUI() {
        
        tblAddPayment.reloadData()
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
        
        let controller = NavigationManager.shared.addPaymentVC
        push(controller: controller)
        
    }
    
    
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

