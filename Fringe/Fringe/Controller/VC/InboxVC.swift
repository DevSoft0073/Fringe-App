//
//  InboxVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 02/09/21.
//

import UIKit
import Alamofire
import Foundation

class InboxVC : BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblInbox: UITableView!
    @IBOutlet weak var noDataLbl: FGSemiboldLabel!
    
    var messageCount : MessageUnreadCount?
    var messagePlayerGroups: [GetAllChatUsers] = []
    var messageGroups: [MessageGroupModal] = []
    
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
        tblInbox.delegate = self
        tblInbox.dataSource = self
        navigationItem.title = LocalizableConstants.Controller.Notifications.title.localized()
        let identifier = String(describing: InboxTVCell.self)
        let nibRequestCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblInbox.register(nibRequestCell, forCellReuseIdentifier: identifier)
        
    }
    
    func updateUI()  {
        noDataLbl.text = LocalizableConstants.Controller.NearByGolfClubs.noChats.localized()
        noDataLbl.isHidden = messagePlayerGroups.count != .zero
        tblInbox.reloadData()
    }
    
    func performGetMessageGroups(isShowLoader: Bool, lastId: String, completion: ((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        var parameter: [String: Any] = [:]
        parameter = [
            Request.Parameter.isHost: PreferenceManager.shared.isHost ?? String(),
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.getAllChats, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<[GetAllChatUsers]>.self) { (response: ResponseModal<[GetAllChatUsers]>) in
            
            self.messagePlayerGroups.removeAll()
            self.messagePlayerGroups.append(contentsOf: response.data ?? [])
            self.messagePlayerGroups = self.messagePlayerGroups.removingDuplicates()
            self.updateUI()
            completion?(true)
            
        } failureBlock: { (errorModal: ErrorModal) in
            
            completion?(false)
        }
    }
    
    func performGetBadgeCount(completion:((_ flag: Bool) -> Void)?) {
        
        let parameter: [String: Any] = [
            Request.Parameter.userID: PreferenceManager.shared.userId ?? String(),
            Request.Parameter.role: PreferenceManager.shared.curretMode ?? String(),
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.badgeCount, parameter: parameter, headers: [:], showLoader: false, decodingType: ResponseModal<BadgeModal>.self, successBlock: { (response: ResponseModal<BadgeModal>) in
                                    
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

    func performMessageUnreadCount(completion:((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.messageUnreadCount, parameter: [:], headers: headers, showLoader: false, decodingType: ResponseModal<MessageUnreadCount>.self, successBlock: { (response: ResponseModal<MessageUnreadCount>) in
                                    
            if response.code == Status.Code.success {
                self.messageCount = response.data
            } else {
                
                completion?(true)
            }
            
            LoadingManager.shared.hideLoading()
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
        })
    }

    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource,UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messagePlayerGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InboxTVCell.self)) as? InboxTVCell {
            cell.selectionStyle = .none
            let data = messagePlayerGroups[indexPath.row]
            cell.setup(messageGroup: data)
            cell.mainSecondImg.kf.setImage(with: URL(string: currentUser?.image ?? ""), placeholder:UIImage(named: FGImageName.iconPlaceHolder))
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let messageGroup = messagePlayerGroups[indexPath.row]
        PreferenceManager.shared.comesFromMessagePush = false
        let controller = NavigationManager.shared.messageListingVC
        controller.roomID = messageGroup.roomID ?? String()
//        controller.senderFirstName = messageGroup.firstName ?? String()
        controller.otherUserName = messageGroup.name ?? String()
        controller.otherUserImg = messageGroup.image ?? String()
        controller.ownImage = messageGroup.image ?? String()
        push(controller: controller)
    }
    
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenuForHost = true
        NavigationManager.shared.isEnabledBottomMenu = true
        var isShowLoader: Bool = false
        if messageGroups.count == .zero {
            isShowLoader = true
        }
        if isShowLoader {
            LoadingManager.shared.showLoading()
        }
        
        self.performMessageUnreadCount { (flag : Bool) in
            
        }
        
        self.performGetBadgeCount { (flag : Bool) in
            
        }
        
        self.performGetMessageGroups(isShowLoader: true, lastId: "") { flag in
            
            if isShowLoader {
                LoadingManager.shared.hideLoading()
            }
            self.updateUI()
        }
    }
    
    //------------------------------------------------------
}
