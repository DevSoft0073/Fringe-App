//
//  GolfclubsVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 13/08/21.
//

import UIKit
import Alamofire
import Foundation
import KRPullLoader

class GolfclubsVC : BaseVC, UITableViewDataSource, UITableViewDelegate, SegmentViewDelegate {
    
    @IBOutlet weak var noDataLbl: FGRegularLabel!
    @IBOutlet weak var segment2: SegmentView!
    @IBOutlet weak var segment1: SegmentView!
    @IBOutlet weak var tblGolf: UITableView!
    
    var isSelected = "0"
    var items : [RequestListingModal] = []
    var isRequesting: Bool = false
    var lastRequestId: String = String()
    var needToshowInfoView: Bool = false
    var btnTapped = true
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Custom
    
    func setup() {
        
        if PreferenceManager.shared.comesFromConfirmToPay == "0"{
            
            tblGolf.dataSource = self
            tblGolf.delegate = self
            noDataLbl.text = LocalizableConstants.Controller.FringeDataForGolfclub.pending.localized()
            segment1.btn.setTitle("Pending", for: .normal)
            segment2.btn.setTitle("Confirmed", for: .normal)
            
            segment1.delegate = self
            segment2.delegate = self
            
            segment1.isSelected = true
            segment2.isSelected = !segment1.isSelected
            var identifier = String(describing: FringePendingCell.self)
            var nibCell = UINib(nibName: identifier, bundle: Bundle.main)
            tblGolf.register(nibCell, forCellReuseIdentifier: identifier)
            
            identifier = String(describing: FringeConfirmedCell.self)
            nibCell = UINib(nibName: identifier, bundle: Bundle.main)
            tblGolf.register(nibCell, forCellReuseIdentifier: identifier)
            
        } else {
            
            tblGolf.dataSource = self
            tblGolf.delegate = self
            noDataLbl.text = LocalizableConstants.Controller.FringeDataForGolfclub.pending.localized()
            segment1.btn.setTitle("Pending", for: .normal)
            segment2.btn.setTitle("Confirmed", for: .normal)
            
            segment1.delegate = self
            segment2.delegate = self
            isSelected = "1"
            segment1.isSelected = false
            segment2.isSelected = true
            var identifier = String(describing: FringePendingCell.self)
            var nibCell = UINib(nibName: identifier, bundle: Bundle.main)
            tblGolf.register(nibCell, forCellReuseIdentifier: identifier)
            
            identifier = String(describing: FringeConfirmedCell.self)
            nibCell = UINib(nibName: identifier, bundle: Bundle.main)
            tblGolf.register(nibCell, forCellReuseIdentifier: identifier)
            
        }
        
        //        tblGolf.dataSource = self
        //        tblGolf.delegate = self
        //        noDataLbl.text = LocalizableConstants.Controller.FringeDataForGolfclub.pending.localized()
        //        segment1.btn.setTitle("Pending", for: .normal)
        //        segment2.btn.setTitle("Confirmed", for: .normal)
        //
        //        segment1.delegate = self
        //        segment2.delegate = self
        //
        //        segment1.isSelected = true
        //        segment2.isSelected = !segment1.isSelected
        //
        //        var identifier = String(describing: FringePendingCell.self)
        //        var nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        //        tblGolf.register(nibCell, forCellReuseIdentifier: identifier)
        //
        //        identifier = String(describing: FringeConfirmedCell.self)
        //        nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        //        tblGolf.register(nibCell, forCellReuseIdentifier: identifier)
        
    }
    
    func updateUI()  {
        
        tblGolf.reloadData()
        
        if items.count == 0{
            self.noDataLbl.isHidden = false
        }else{
            self.noDataLbl.isHidden = true
        }
        
        if segment1.isSelected == true {
            
            noDataLbl.text = LocalizableConstants.Controller.GolfClubs.pending.localized()
            noDataLbl.isHidden = items.count != .zero
            
        }else{
            
            noDataLbl.text = LocalizableConstants.Controller.GolfClubs.confirmed.localized()
            noDataLbl.isHidden = items.count != .zero
            
        }
    }
    
    func performGetBookingListing(completion:((_ flag: Bool) -> Void)?) {
        
        var parameter: [String: Any] = [:]
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        self.noDataLbl.isHidden = true
        
        if segment1.isSelected == true {
            
            parameter = [Request.Parameter.userID: currentUser?.userID ?? String(),
                         Request.Parameter.bookedStatus: isSelected,
                         Request.Parameter.lastID: lastRequestId,]
            
        } else if segment2.isSelected == true {
            
            parameter = [Request.Parameter.userID: currentUser?.userID ?? String(),
                         Request.Parameter.bookedStatus: isSelected,
                         Request.Parameter.lastID: lastRequestId,]
            
        }  else {
            
            segment1.isSelected = true
            
            parameter = [Request.Parameter.userID: currentUser?.userID ?? String(),
                         Request.Parameter.bookedStatus: "0",
                         Request.Parameter.lastID: lastRequestId,]
            
        }
        
        
        isRequesting = true
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.bookingListForPlayer, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<[RequestListingModal]>.self, successBlock: { (response: ResponseModal<[RequestListingModal]>) in
            
            LoadingManager.shared.hideLoading()
            
            self.isRequesting = false
            
            if response.code == Status.Code.success {
                
                if self.lastRequestId.isEmpty {
                    self.items.removeAll()
                    self.updateUI()
                    
                }
                
                self.items.append(contentsOf: response.data ?? [])
                self.items = self.items.removingDuplicates()
                self.lastRequestId = response.data?.last?.id ?? String()
                self.updateUI()
                
            } else if response.code == Status.Code.nofoundDat {
                
                LoadingManager.shared.hideLoading()
                
                self.updateUI()
                
                self.noDataLbl.isHidden = false
                
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            
            DisplayAlertManager.shared.displayAlert(target: self, animated: false, message: error.localizedDescription) {
                PreferenceManager.shared.userId = nil
                PreferenceManager.shared.currentUser = nil
                PreferenceManager.shared.authToken = nil
                NavigationManager.shared.setupSingIn()
            }
        })
    }
    
    private func performRequestCancelation(golfID : String,completion:((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        let parameterr: [String: Any] = [
            Request.Parameter.userID: PreferenceManager.shared.userId ?? String(),
            Request.Parameter.id: golfID,
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.cancleRequest, parameter: parameterr, headers: headers, showLoader: false, decodingType: BaseResponseModal.self.self, successBlock: { (response: BaseResponseModal) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                
                delay {
                    
                    DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.SuccessMessage.cancellationRequestSubmit.localized()) {
                        self.lastRequestId = ""
                        self.items.removeAll()
                        
                        LoadingManager.shared.showLoading()
                        
                        self.performGetBookingListing { (flag: Bool) in
                        }
                    }
                    
                    completion?(true)
                }
                
            } else if response.code == Status.Code.notfound {
                
                self.noDataLbl.isHidden = false
                
            }else {
                
                completion?(false)
                
                delay {
                    
                    //                    self.handleError(code: response.code)
                }
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            delay {
                DisplayAlertManager.shared.displayAlert(animated: true, message: LocalizableConstants.Error.anotherLogin, handlerOK: nil)
                PreferenceManager.shared.userId = nil
                PreferenceManager.shared.currentUser = nil
                PreferenceManager.shared.authToken = nil
                NavigationManager.shared.setupSingIn()
            }
        })
    }
    
    func performGetBadgeCount(completion:((_ flag: Bool) -> Void)?) {
        
        let parameter: [String: Any] = [
            Request.Parameter.userID: PreferenceManager.shared.userId ?? String(),
            Request.Parameter.role: PreferenceManager.shared.curretMode ?? String(),
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.badgeCount, parameter: parameter, headers: [:], showLoader: false, decodingType: ResponseModal<BadgeModal>.self, successBlock: { (response: ResponseModal<BadgeModal>) in
                        
            self.isRequesting = false
            
            if response.code == Status.Code.success {
                
                if let stringUser = try? response.data?.jsonString() {
                    
                    PreferenceManager.shared.badgeModal = stringUser
                    
                }
                
            } else {
                
                completion?(true)
            }
            
            LoadingManager.shared.hideLoading()
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            self.isRequesting = false
            
//            delay {
//
//                DisplayAlertManager.shared.displayAlert(target: self, animated: false, message: error.localizedDescription) {
//                    PreferenceManager.shared.userId = nil
//                    PreferenceManager.shared.currentUser = nil
//                    PreferenceManager.shared.authToken = nil
//                    NavigationManager.shared.setupSingIn()
//                }
//            }
        })
    }

    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segment1.isSelected {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FringePendingCell.self)) as? FringePendingCell {
                if items.count > 0{
                    let data = items[indexPath.row]
                    cell.btnMoreInfo.tag = indexPath.row
                    cell.btnMoreInfo.addTarget(self, action: #selector(showHideView), for: .touchUpInside)
                    cell.btnClose.tag = indexPath.row
                    if needToshowInfoView {
                        cell.cancelView.isHidden = true
                        cell.btnClose.isHidden = true
                        cell.btnMoreInfo.isHidden = false
                    }
                    cell.setup(bookingData: data)
                    cell.btnClose.addTarget(self, action: #selector(showViews), for: .touchUpInside)
                    cell.btnCancelation.addTarget(self, action: #selector(cancelBooking), for: .touchUpInside)
                    return cell
                } else {
                    
                }
            }
        } else if segment2.isSelected {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FringeConfirmedCell.self)) as? FringeConfirmedCell{
                if items.count > 0{
                    let data = items[indexPath.row]
                    cell.btnPay.tag = indexPath.row
                    cell.btnPay.addTarget(self, action: #selector(showPayView), for: .touchUpInside)
                    if needToshowInfoView {
                        cell.refundRequestView.isHidden = true
                        cell.btnPay.isHidden = false
                    }
                    if data.paymentStatus == "0" {
                        cell.btnPay.setTitle("Pay", for: .normal)
                        cell.btnPay.isUserInteractionEnabled = true
                    } else {
                        cell.btnPay.setTitle("Paid", for: .normal)
                        cell.btnPay.isUserInteractionEnabled = false
                    }
                    cell.setup(bookingData: data)
                    cell.btnRefundRequest.addTarget(self, action: #selector(showRequestView), for: .touchUpInside)
                    return cell
                }else{
                    
                }
            }
            
        } else {
            
        }
        
        return UITableViewCell()
    }
    
    //------------------------------------------------------
    
    //  MARK: Actions
    
    @objc func showHideView(sender : UIButton) {
        if let cell = sender.superview?.superview?.superview?.superview?.superview as? FringePendingCell{
            self.needToshowInfoView = false
            cell.cancelView.isHidden = false
            cell.btnClose.isHidden = false
            cell.btnMoreInfo.isHidden = true
            tblGolf.reloadData()
            btnTapped = false
        }
    }
    
    @objc func showViews(sender : UIButton) {
        if let cell = sender.superview?.superview?.superview?.superview?.superview as? FringePendingCell{
            btnTapped = true
            cell.cancelView.isHidden = true
            cell.btnClose.isHidden = true
            cell.btnMoreInfo.isHidden = false
            tblGolf.reloadData()
        }
    }
    
    @objc func showPayView(sender : UIButton) {
        if let cell = sender.superview?.superview?.superview?.superview?.superview as? FringeConfirmedCell{
            btnTapped = true
            let data = items[sender.tag]
            PreferenceManager.shared.comesFromConfirmToPay = "1"
            let controller = NavigationManager.shared.confirmedPayVC
            controller.detailsData = data
            controller.isUpdate = {
                self.isSelected = "0"
            }
            push(controller: controller)
            cell.refundRequestView.isHidden = true
            tblGolf.reloadData()
        }
    }
    
    @objc func cancelBooking(sender : UIButton) {
        let data = items[sender.tag]
        
        LoadingManager.shared.showLoading()
        
        self.performRequestCancelation(golfID: data.id ?? String()) { (flag : Bool) in
            
        }
    }
    
    @objc func showRequestView(sender : UIButton) {
        if let cell = sender.superview?.superview?.superview?.superview?.superview as? FringeConfirmedCell{
            btnTapped = true
            cell.refundRequestView.isHidden = false
            tblGolf.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    //------------------------------------------------------
    
    //MARK: SegmentViewDelegate
    
    func segment(view: SegmentView, didChange flag: Bool) {
        
        tblGolf.reloadData()
        
        self.items.removeAll()
        
        self.lastRequestId = ""
        
        self.needToshowInfoView = true
        
        if view == segment1 {
            
            isSelected = "0"
            
            LoadingManager.shared.showLoading()
            
            PreferenceManager.shared.comesFromConfirmToPay = "1"
            
            self.performGetBookingListing { (flag : Bool) in
                
            }
            
            segment2.isSelected = false
            
        } else if view == segment2 {
            
            isSelected = "1"
            
            LoadingManager.shared.showLoading()
            
            self.performGetBookingListing { (flag : Bool) in
                
            }
            
            segment1.isSelected = false
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PreferenceManager.shared.comesFromConfirmToPay = "0"
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        noDataLbl.isHidden = false
                
//        isSelected = "0"
        
        self.lastRequestId = ""
        
        LoadingManager.shared.showLoading()
        
        self.performGetBookingListing { (flag : Bool) in
            
        }
        
        self.performGetBadgeCount { (flag : Bool) in
            
        }
        
        NavigationManager.shared.isEnabledBottomMenu = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setup()
    }
    
    //------------------------------------------------------
    
}
