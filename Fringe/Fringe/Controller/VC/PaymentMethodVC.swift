//
//  PaymentMethodVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 04/09/21.
//

import UIKit
import Alamofire
import Foundation
import IQKeyboardManagerSwift

class PaymentMethodVC : BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addPayBtn: FGActiveButton!
    @IBOutlet weak var noDataLbl: FGRegularLabel!
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet weak var tblPayment: UITableView!
    
    var isRequesting: Bool = false
    var lastRequestId: String = String()
    var textTitle: String?
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var items = [PaymentDataModel]()
    
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
        noDataLbl.text = LocalizableConstants.Controller.CardListing.noCard.localized()
        noDataLbl.isHidden = items.count != .zero
        tblPayment.reloadData()
    }
    
    func performGetCardListing(completion:((_ flag: Bool) -> Void)?) {
        
        isRequesting = true
        
        let headers:HTTPHeaders = [
           "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
          ]
        
        let parameter: [String: Any] = [
            Request.Parameter.userID: PreferenceManager.shared.userId ?? String(),
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.cardListing, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<[PaymentDataModel]>.self, successBlock: { (response: ResponseModal<[PaymentDataModel]>) in
            
            LoadingManager.shared.hideLoading()
            
            self.isRequesting = false
            
            if response.code == Status.Code.success {
                
                delay {
                    
                    if self.lastRequestId.isEmpty {
                        
                        self.items.removeAll()
                    }
                    
                    self.items.append(contentsOf: response.data ?? [])
                    self.setup()
                    self.updateUI()
                }
                
            } else if response.code == Status.Code.notfound {
                
                self.items.removeAll()
                
//                self.addBtn.isHidden = true
                                
            } else {
                
                self.items.removeAll()
                
                completion?(true)
            }
            
            LoadingManager.shared.hideLoading()
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            self.isRequesting = false
            
            delay {
                DisplayAlertManager.shared.displayAlert(animated: true, message: error.errorDescription, handlerOK: nil)
            }
        })
    }

    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        let controller = NavigationManager.shared.addPaymentVC
        push(controller: controller)
    }
    
    @IBAction func btnPayment(_ sender: Any) {
        let controller = NavigationManager.shared.paymentSuccessfullyPopUpVC
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
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
        if let cell = tableView.cellForRow(at: indexPath) as? PaymentMethodTVC{
            cell.selectUnselectImg.image = UIImage(named: FGImageName.iconRadio)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PaymentMethodTVC{
            cell.selectUnselectImg.image = UIImage(named: FGImageName.iconRadioUnselect)
        }
    }
    
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLbl.isHidden = true
        setup()
        
        LoadingManager.shared.showLoading()
        
        self.performGetCardListing { (flag : Bool) in
            
        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
