//
//  MyBookingVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 19/08/21.
//

import UIKit
import Foundation
import Alamofire
import KRPullLoader
import IQKeyboardManagerSwift

class MyBookingVC : BaseVC , UITableViewDelegate , UITableViewDataSource, KRPullLoadViewDelegate{
    
    @IBOutlet weak var noDataLbl: FGRegularLabel!
    @IBOutlet weak var tblBooking: UITableView!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var items: [BookingModal] = []
    var isRequesting: Bool = false
    var lastRequestId: String = String()
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
        tblBooking.delegate = self
        tblBooking.dataSource = self
       
        let loadMoreView = KRPullLoadView()
        loadMoreView.delegate = self
        tblBooking.addPullLoadableView(loadMoreView, type: .refresh)
        
        let identifier = String(describing: MyBookingTVCell.self)

        let nibRequestCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblBooking.register(nibRequestCell, forCellReuseIdentifier: identifier)
        
    }
    
    func updateUI() {
        noDataLbl.text = LocalizableConstants.Controller.Pages.noDataFound.localized()
        noDataLbl.isHidden = items.count != .zero
        tblBooking.reloadData()
    }
    
    func performBokkings(completion:((_ flag: Bool) -> Void)?) {
        
        isRequesting = true
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        let parameter: [String: Any] = [
            Request.Parameter.lastID: lastRequestId,
            Request.Parameter.userID: PreferenceManager.shared.userId ?? String(),
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.myBooking, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<[BookingModal]>.self, successBlock: { (response: ResponseModal<[BookingModal]>) in
            
            LoadingManager.shared.hideLoading()
            
            self.isRequesting = false
            
            if response.code == Status.Code.success {
                
                delay {
                    
                    if self.lastRequestId.isEmpty {
                        
                        self.items.removeAll()
                    }
                    self.items.append(contentsOf: response.data ?? [])
                    self.items = self.items.removingDuplicates()
                    self.lastRequestId = response.data?.last?.id ?? String()
                    self.updateUI()
                }
            } else if response.code == Status.Code.notfound {
                
//                self.updateUI()
                
            } else {
                
                
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
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MyBookingTVCell.self)) as? MyBookingTVCell {
            let data = items[indexPath.row]
            cell.setup(bookingData: data)
            DispatchQueue.main.async {
                cell.imgMain.roundCornersLeft( [.topLeft, .bottomLeft],radius: 16)
            }
           
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = items[indexPath.row]
        let controller = NavigationManager.shared.bookingDetailsVC
        controller.bookingDetails = data
        push(controller: controller)
    }
    
    
    //------------------------------------------------------
    
    //MARK: KRPullLoadViewDelegate
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        
        if type == .refresh {
            switch state {
            case .none:
                pullLoadView.messageLabel.text = String()
            case let .pulling(offset, threshould):
                if offset.y > threshould {
                    pullLoadView.messageLabel.text = LocalizableConstants.Controller.Pages.pullMore.localized()
                } else {
                    pullLoadView.messageLabel.text = LocalizableConstants.Controller.Pages.releaseToRefresh.localized()
                }
            case let .loading(completionHandler):
                pullLoadView.messageLabel.text = LocalizableConstants.Controller.Pages.updating.localized()
                if isRequesting == false {
                    performBokkings { (flag: Bool) in
                        self.updateUI()
                        completionHandler()
                    }
                } else {
                    completionHandler()
                }
            }
        } else if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                if isRequesting == false {
                    performBokkings { (flag: Bool) in
                        self.updateUI()
                        completionHandler()
                    }
                } else {
                    completionHandler()
                }
            default: break
            }
            return
        }
    }
    
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingManager.shared.showLoading()
        
        setup()
        
        performBokkings { (flag : Bool) in
            
        }
       
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenu = false
    }
    
    //------------------------------------------------------
}
