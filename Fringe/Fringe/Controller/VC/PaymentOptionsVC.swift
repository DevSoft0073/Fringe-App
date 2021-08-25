//
//  PaymentOptionsVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 25/08/21.
//
import UIKit
import Foundation

class PaymentOptionsVC : BaseVC, UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var lblTotalPayment: FGRegularLabel!
    @IBOutlet weak var tblPayment: UITableView!
    struct PaymentItems {
        static let creditCard = LocalizableConstants.Controller.AddPaymentMethod.creditDebitCard
        static let creditCardIcon = FGImageName.iconCreditCardPayment
        static let payPal = LocalizableConstants.Controller.AddPaymentMethod.payPalCard
        static let payPalIcon = FGImageName.iconPayPayment
        static let applePay = LocalizableConstants.Controller.AddPaymentMethod.appleCard
        static let applePayIcon = FGImageName.iconApplePayment
    }
    var itemNormal: [ [String:String] ] {
        return [
            ["name": PaymentItems.creditCard, "image": PaymentItems.creditCardIcon],
            ["name": PaymentItems.payPal, "image": PaymentItems.payPalIcon],
            ["name": PaymentItems.applePay, "image": PaymentItems.applePayIcon],
         
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
    
    //MARK: Customs
    
    func setup() {
        tblPayment.delegate = self
        tblPayment.dataSource = self
        navigationItem.title = LocalizableConstants.Controller.Notifications.title.localized()
        
//        let loadMoreView = KRPullLoadView()
//        loadMoreView.delegate = self
//        tblNotification.addPullLoadableView(loadMoreView, type: .refresh)
        
        let identifier = String(describing: PaymentOptionsTBCell.self)

        let nibRequestCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblPayment.register(nibRequestCell, forCellReuseIdentifier: identifier)
        
    }
    func updateUI() {
        
        tblPayment.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    //------------------------------------------------------
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let name = item["name"]
        let image = item["image"]!
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionsTBCell", for: indexPath) as! PaymentOptionsTBCell
        
            cell.setup(image: image, name: name?.localized())
        
            return cell
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
           
       
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
}
