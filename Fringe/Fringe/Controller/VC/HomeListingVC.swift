//
//  HomeListingVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 25/08/21.
//

import UIKit
import Alamofire
import Foundation
import KRPullLoader
import IQKeyboardManagerSwift

class HomeListingVC : BaseVC, UITableViewDataSource, UITableViewDelegate, KRPullLoadViewDelegate{
    
    @IBOutlet weak var noDataLbl: FGMediumLabel!
    @IBOutlet weak var txtSearchFld: FGRegularTextField!
    @IBOutlet weak var tblListing: UITableView!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var items: [HomeModal] = []
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
    
    func setup(){
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        tblListing.delegate = self
        tblListing.dataSource = self
        
        let loadMoreView = KRPullLoadView()
        loadMoreView.delegate = self
        tblListing.addPullLoadableView(loadMoreView, type: .loadMore)
        
        
        let identifier = String(describing: HomeListingTBCell.self)
        let nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblListing.register(nibProfileCell, forCellReuseIdentifier: identifier)
        
    }
    
    static func instantiate() -> HomeListingVC {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "HomeListingVC") as! HomeListingVC
    }
    
    func updateUI() {
        noDataLbl.text = LocalizableConstants.Controller.NearByGolfClubs.noSessionDataFound.localized()
        noDataLbl.isHidden = items.count != .zero
        tblListing.reloadData()
    }
    
    func performGetNearByGolfClubs(completion:((_ flag: Bool) -> Void)?) {
        
        isRequesting = true
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": currentUser?.authorizationToken ?? String(),
//            "Token": "IB6WSFnebwuDro5mhQxP5Lai4bW8ZZ9laDQbdU1vpvrk8F9HO9"
        ]
        
        let parameter: [String: Any] = [
            Request.Parameter.lastID: lastRequestId,
            Request.Parameter.lats : "30.723539",
            Request.Parameter.longs: "76.787277",
            Request.Parameter.search: "",
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.home, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<[HomeModal]>.self, successBlock: { (response: ResponseModal<[HomeModal]>) in
            
            //            LoadingManager.shared.hideLoading()
            
            self.isRequesting = false
            
            if response.code == Status.Code.success {
                
                delay {
                    
                    if self.lastRequestId.isEmpty {
                        
                        self.items.removeAll()
                    }
                    self.items.append(contentsOf: response.data ?? [])
                    self.items = self.items.removingDuplicates()
                    self.lastRequestId = response.data?.last?.golfID ?? String()
                    self.updateUI()
                }
            }
            else {
                
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
    
    @IBAction func btnNotification(_ sender: Any) {
        let controller = NavigationManager.shared.notificationVC
        push(controller: controller)
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource , UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeListingTBCell.self)) as? HomeListingTBCell {
            let data = items[indexPath.row]
            cell.setup(homeData: data)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = items[indexPath.row]
        let controller = NavigationManager.shared.detailsScreenVC
        controller.detailsData = data
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
                    performGetNearByGolfClubs { (flag: Bool) in
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
                    performGetNearByGolfClubs { (flag: Bool) in
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
        self.updateUI()
                
        self.performGetNearByGolfClubs { (flag : Bool) in
            
        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    //------------------------------------------------------
}
