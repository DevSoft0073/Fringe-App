//
//  PaymentMethodVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 04/09/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class PaymentMethodVC : BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addPayBtn: FGActiveButton!
    @IBOutlet weak var noDataLbl: FGRegularLabel!
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet weak var tblPayment: UITableView!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    func setup() {
        tblPayment.dataSource = self
        tblPayment.delegate = self
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        self.updateUI()
        
        let identifier = String(describing: PaymentMethodTVC.self)
        
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
    
    @IBAction func btnAdd(_ sender: Any) {
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PaymentMethodTVC.self)) as? PaymentMethodTVC {
            DispatchQueue.main.async {
                self.heightContraint.constant = self.tblPayment.contentSize.height
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = NavigationManager.shared.addPaymentVC
        push(controller: controller)
    }
    
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLbl.isHidden = true
        setup()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
