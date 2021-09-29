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

class ClubSearchVC : BaseVC, UITableViewDataSource, UITableViewDelegate, KRPullLoadViewDelegate , UISearchBarDelegate ,UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var noDataLbl: FGRegularLabel!
    @IBOutlet weak var txtSearchFld: FGRegularTextField!
    @IBOutlet weak var tblListing: UITableView!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var items: [HomeModal] = []
    var isRequesting: Bool = false
    var lastRequestId: String = String()
    var debounce: FGDebouncer?
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
        tblListing.addPullLoadableView(loadMoreView, type: .refresh)
        debounce = FGDebouncer.init(delay: 0.2, callback: {
            self.lastRequestId = ""
            self.performGetNearByStudios { (flag: Bool) in
                self.updateUI()
            }
        })
        
        let identifier = String(describing: HomeListingTBCell.self)
        let nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblListing.register(nibProfileCell, forCellReuseIdentifier: identifier)
        
    }
    
    func updateUI()  {
        
        noDataLbl.isHidden = items.count != .zero
        tblListing.reloadData()
    }
    
    static func instantiate() -> HomeListingVC {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "HomeListingVC") as! HomeListingVC
    }
    
    func performGetNearByStudios(completion:((_ flag: Bool) -> Void)?) {
        
        isRequesting = true
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        let parameter: [String: Any] = [
            Request.Parameter.lastID: lastRequestId,
            Request.Parameter.lats : PreferenceManager.shared.lat ?? String(),
            Request.Parameter.longs: PreferenceManager.shared.long ?? String(),
            Request.Parameter.search: txtSearchFld.text ?? String(),
        ]
        RequestManager.shared.requestPOST(requestMethod: Request.Method.home, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<[HomeModal]>.self, successBlock: { (response: ResponseModal<[HomeModal]>) in
            
            LoadingManager.shared.hideLoading()
            
            self.isRequesting = false
            
            if response.code == Status.Code.success {
                
                delay {
                    
                    if self.lastRequestId.isEmpty {
                        
                        self.items.removeAll()
                    }
                    
                    self.items.append(contentsOf: response.data ?? [])
                    self.items = self.items.removingDuplicates()
                    self.lastRequestId = response.data?.first?.golfID ?? String()
                    self.updateUI()
                }
                
            } else if response.code == Status.Code.notfound {
                                                
                self.updateUI()
                
            } else {
                                                
                completion?(true)
            }
            
            LoadingManager.shared.hideLoading()
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            self.isRequesting = false
            
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
        NavigationManager.shared.setupDetails(detailsData: data)
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
                    performGetNearByStudios { (flag: Bool) in
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
                    performGetNearByStudios { (flag: Bool) in
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
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == txtSearchFld {
//            self.performGetNearByStudios { (flag : Bool) in
//                
//            }
//        }
//        return true
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtSearchFld {
            
            items.removeAll()
            
            self.lastRequestId = ""
            
            LoadingManager.shared.showLoading()
            
            self.performGetNearByStudios { (flag : Bool) in
                
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearchFld.delegate = self
        self.updateUI()
        self.setup()
        self.performGetNearByStudios { (flag : Bool) in
            
        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    //------------------------------------------------------
}
