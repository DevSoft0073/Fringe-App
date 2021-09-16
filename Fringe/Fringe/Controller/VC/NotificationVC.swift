//
//  NotificationVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 12/08/21.
//

import UIKit
import Alamofire
import Foundation
import KRPullLoader

class NotificationVC : BaseVC, UITableViewDelegate , UITableViewDataSource, KRPullLoadViewDelegate{
    
    @IBOutlet weak var noDataLbl: FGRegularLabel!
    @IBOutlet weak var tblNotification: UITableView!
    
    var items: [NotificationModal] = []
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
        tblNotification.delegate = self
        tblNotification.dataSource = self
        navigationItem.title = LocalizableConstants.Controller.Notifications.title.localized()
        
        let loadMoreView = KRPullLoadView()
        loadMoreView.delegate = self
        tblNotification.addPullLoadableView(loadMoreView, type: .refresh)
        
        let identifier = String(describing: NotificationTVCell.self)
        
        let nibRequestCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblNotification.register(nibRequestCell, forCellReuseIdentifier: identifier)
        
    }
    
    func updateUI() {
        tblNotification.reloadData()
    }
    
    private func performToGetAllNotificationListing(completion:((_ flag: Bool) -> Void)?) {
        
        isRequesting = true
        
        let headers:HTTPHeaders = [
           "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
          ]
        
        let parameter: [String: Any] = [
            Request.Parameter.userID: "2",
            Request.Parameter.lastID: self.lastRequestId,
        ]
        
        print("notifParam",parameter)
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.notification, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<[NotificationModal]>.self, successBlock: { (response: ResponseModal<[NotificationModal]>) in
            
            LoadingManager.shared.hideLoading()
            
            self.isRequesting = false
            
            if response.code == Status.Code.success {
                if self.lastRequestId.isEmpty {
                    self.items.removeAll()
                    self.updateUI()
                }
                
                self.items.append(contentsOf: response.data ?? [])
                self.items = self.items.removingDuplicates()
                self.lastRequestId = response.data?.first?.notificationID ?? String()
                self.updateUI()
                completion?(true)
                
            } else {
                completion?(true)
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            self.isRequesting = false
            completion?(false)
            
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
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource,UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NotificationTVCell.self)) as? NotificationTVCell {
            let data = items[indexPath.row]
            cell.setUp(notificationData: data)
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
                    self.lastRequestId = String()
                    performToGetAllNotificationListing { (flag: Bool) in
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
                    self.lastRequestId = String()
                    performToGetAllNotificationListing { (flag: Bool) in
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
        
        setup()
        
        LoadingManager.shared.showLoading()
        
        performToGetAllNotificationListing { (flag : Bool) in
            
        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenu = false
        
    }
}



