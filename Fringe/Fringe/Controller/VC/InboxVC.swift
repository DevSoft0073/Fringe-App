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
    @IBOutlet weak var noDataLbl: FGRegularLabel!
    
    var messageStudioGroups: [PlayerMessgaeModal] = []
    
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
        tblInbox.reloadData()
    }
    
    func performGetMessageGroups(isShowLoader: Bool, lastId: String, completion: ((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.chatListing, parameter: [:], headers: headers, showLoader: false, decodingType: ResponseModal<[PlayerMessgaeModal]>.self) { (response: ResponseModal<[PlayerMessgaeModal]>) in
            
            self.messageStudioGroups = response.data ?? []
            completion?(true)
            
        } failureBlock: { (errorModal: ErrorModal) in
            
            completion?(false)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource,UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageStudioGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InboxTVCell.self)) as? InboxTVCell {
            cell.selectionStyle = .none
            let data = messageStudioGroups[indexPath.row]
            cell.setup(messageGroup: data)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = NavigationManager.shared.chatDetailsVC
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
        
//        var isShowLoader: Bool = false
//        if messageGroups.count == .zero {
//            isShowLoader = true
//        }
//        if isShowLoader {
//            LoadingManager.shared.showLoading()
//        }
        self.performGetMessageGroups(isShowLoader: true, lastId: "") { flag in
            
//            if isShowLoader {
//                LoadingManager.shared.hideLoading()
//            }
            self.updateUI()
        }
    }
    
    //------------------------------------------------------
}
