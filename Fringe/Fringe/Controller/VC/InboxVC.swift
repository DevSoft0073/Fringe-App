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
    
    var messagePlayerGroups: [PlayerMessgaeModal] = [] {
        didSet {
            messagePlayerGroups.forEach { (arg0: PlayerMessgaeModal) in
                if messageGroups.contains(where: { (arg1: MessageGroupModal) in
                    return arg0.lastid == arg1.lastid
                }) == false {
                    messageGroups.append(arg0.toMessageGroupModal())
                } else {
                    if let index = messageGroups.firstIndex(where: { (group: MessageGroupModal) in
                        return arg0.lastid == group.lastid
                    }) {
                        messageGroups[index] = arg0.toMessageGroupModal()
                    }
                }
                messageGroups.sort { message1, message2 in
                    return message1.unixDate > message2.unixDate
                }
            }
        }
    }
    
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
        //
        //        let loadMoreView = KRPullLoadView()
        //        loadMoreView.delegate = self
        //        tblInbox.addPullLoadableView(loadMoreView, type: .refresh)
        
        let identifier = String(describing: InboxTVCell.self)
        
        let nibRequestCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblInbox.register(nibRequestCell, forCellReuseIdentifier: identifier)
        
    }
    
    func updateUI()  {
        noDataLbl.text = LocalizableConstants.Controller.NearByGolfClubs.noChats.localized()
        noDataLbl.isHidden = messageGroups.count != .zero
        tblInbox.reloadData()
    }
    
    func performGetMessageGroups(isShowLoader: Bool, lastId: String, completion: ((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.chatListing, parameter: [:], headers: headers, showLoader: false, decodingType: ResponseModal<[PlayerMessgaeModal]>.self) { (response: ResponseModal<[PlayerMessgaeModal]>) in
            
            self.messageGroups.removeAll()
            self.messagePlayerGroups.removeAll()
            self.messagePlayerGroups.append(contentsOf: response.data ?? [])
            self.messagePlayerGroups = self.messagePlayerGroups.removingDuplicates()
            self.tblInbox.reloadData()
            completion?(true)
            
        } failureBlock: { (errorModal: ErrorModal) in
            
            completion?(false)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource,UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InboxTVCell.self)) as? InboxTVCell {
            cell.selectionStyle = .none
            let data = messageGroups[indexPath.row]
            cell.setup(messageGroup: data)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let messageGroup = messageGroups[indexPath.row]
        let controller = NavigationManager.shared.messageListingVC
        controller.roomID = messageGroup.roomID ?? String()
        controller.senderFirstName = messageGroup.firstName ?? String()
        controller.senderLastName = messageGroup.lastName ?? String()
        controller.otherUserImg = messageGroup.otheruserImage ?? String()
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
        
        self.performGetMessageGroups(isShowLoader: true, lastId: "") { flag in
            
            if isShowLoader {
                LoadingManager.shared.hideLoading()
            }
            self.updateUI()
        }
    }
    
    //------------------------------------------------------
}
