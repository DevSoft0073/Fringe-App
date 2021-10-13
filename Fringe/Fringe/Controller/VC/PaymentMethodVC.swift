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
    @IBOutlet weak var noDataLbl: FGSemiboldLabel!
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet weak var tblPayment: UITableView!
    
    var comesFrom = String()
    var totalGuest = String()
    var totalAmmount = String()
    var detailsData: RequestListingModal?
    var selectedCategories: [String] = []
    var cardId = String()
    var isComesFrom = Bool()
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
                    self.items = self.items.removingDuplicates()
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
                
                DisplayAlertManager.shared.displayAlert(target: self, animated: false, message: error.localizedDescription) {
                    PreferenceManager.shared.userId = nil
                    PreferenceManager.shared.currentUser = nil
                    PreferenceManager.shared.authToken = nil
                    NavigationManager.shared.setupSingIn()
                }
            }

        })
    }
    
    private func performSendPayment(completion:((_ flag: Bool) -> Void)?) {

        let headers:HTTPHeaders = [
           "content-type": "application/json",
//            "Token": PreferenceManager.shared.authToken ?? String(),
          ]
        
        let parameter: [String: Any] = [
            Request.Parameter.userID: PreferenceManager.shared.userId ?? String(),
            Request.Parameter.golfID: detailsData?.golfID ?? String(),
            Request.Parameter.id: detailsData?.id ?? String(),
            Request.Parameter.token: cardId,
            Request.Parameter.totalAmount: totalAmmount,
            Request.Parameter.totalGuest: totalGuest,
        ]

        RequestManager.shared.requestPOST(requestMethod: Request.Method.payNow, parameter: parameter, headers: headers, showLoader: false, decodingType: BaseResponseModal.self, successBlock: { (response: BaseResponseModal) in

            LoadingManager.shared.hideLoading()

            if response.code == Status.Code.success {

                delay {
                    completion?(true)
                }
                
            } else {

                delay {
                    DisplayAlertManager.shared.displayAlert(animated: true, message: response.message ?? String(), handlerOK: nil)
                }

            }

        }, failureBlock: { (error: ErrorModal) in

            LoadingManager.shared.hideLoading()

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
        
        LoadingManager.shared.showLoading()
        
        self.performSendPayment { (flag : Bool) in
            let controller = NavigationManager.shared.paymentSuccessfullyPopUpVC
            controller.modalPresentationStyle = .overFullScreen
            controller.modalTransitionStyle = .flipHorizontal
            self.present(controller, animated: true)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PaymentMethodTVC.self)) as? PaymentMethodTVC {
            let data = items[indexPath.row]
            cell.setup(cardData: data, comesFromm: comesFrom)
            cell.iconImage.setRounded()
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
        let name = items[indexPath.row].cardHolderName
        if selectedCategories.contains(name ?? "") == false {
            selectedCategories.append(name ?? "")
            if let cell = tableView.cellForRow(at: indexPath) as? PaymentMethodTVC {
                cell.selectUnselectImg.image = UIImage(named: FGImageName.iconCheck)
                self.cardId = items[indexPath.row].cardID ?? String()
            }
        }

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let name = items[indexPath.row].cardHolderName
        if selectedCategories.contains(name ?? "") == true {
            selectedCategories.removeAll { (arg0: String) -> Bool in
                return arg0 == name
            }
            if let cell = tableView.cellForRow(at: indexPath) as? PaymentMethodTVC {
                cell.selectUnselectImg.image = UIImage(named: FGImageName.iconUncheck)
                self.cardId = ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // delete data and row
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tblPayment.reloadData()
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLbl.isHidden = true
        setup()
        if isComesFrom == true {
            self.addPayBtn.isHidden = true
        } else {
            self.addPayBtn.isHidden = false
        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LoadingManager.shared.showLoading()
        
        self.performGetCardListing { (flag : Bool) in
            
        }
        
    }
    
    //------------------------------------------------------
}
