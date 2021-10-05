//
//  FavouriteVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 12/08/21.
//

import UIKit
import Alamofire
import KRPullLoader
import Foundation

class FavouriteVC : BaseVC, UITableViewDelegate, UITableViewDataSource, KRPullLoadViewDelegate{
    
    @IBOutlet weak var noDataLbl: FGSemiboldLabel!
    @IBOutlet weak var tblFavourite: UITableView!
    
    var items: [FavoriteListing] = []
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
        tblFavourite.dataSource = self
        tblFavourite.delegate = self
        navigationItem.title = LocalizableConstants.Controller.Notifications.title.localized()
        
        let loadMoreView = KRPullLoadView()
        loadMoreView.delegate = self
        tblFavourite.addPullLoadableView(loadMoreView, type: .refresh)
        
        let identifier = String(describing: FavouriteTVCell.self)

        let nibRequestCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblFavourite.register(nibRequestCell, forCellReuseIdentifier: identifier)
        
    }
    
    func updateUI() {
        noDataLbl.text = LocalizableConstants.Controller.Pages.noFavData.localized()
        noDataLbl.isHidden = items.count != .zero
        tblFavourite.reloadData()
    }
    
    func performGetFavStudios(completion:((_ flag: Bool) -> Void)?) {

        isRequesting = true

        let headers:HTTPHeaders = [
           "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
          ]
        
        let parameter: [String: Any] = [
            Request.Parameter.lastID: lastRequestId,
        ]

        RequestManager.shared.requestPOST(requestMethod: Request.Method.favoriteListing, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<[FavoriteListing]>.self, successBlock: { (response: ResponseModal<[FavoriteListing]>) in

            LoadingManager.shared.hideLoading()

            self.isRequesting = false
            
            if response.code == Status.Code.success {
                if self.lastRequestId.isEmpty {
                    self.items.removeAll()
                }
                self.items.append(contentsOf: response.data ?? [])
                self.items = self.items.removingDuplicates()
                self.lastRequestId = response.data?.first?.favID ?? String()
                self.updateUI()
                completion?(true)
                
            } else if response.code == Status.Code.notfound {
                
                completion?(true)
                
            } else {
                                
                
                completion?(true)
            }

        }, failureBlock: { (error: ErrorModal) in

            LoadingManager.shared.hideLoading()
            self.isRequesting = false

            delay {
                
                DisplayAlertManager.shared.displayAlert(target: self, animated: false, message: LocalizableConstants.Error.anotherLogin) {
                    PreferenceManager.shared.userId = nil
                    PreferenceManager.shared.currentUser = nil
                    PreferenceManager.shared.authToken = nil
                    NavigationManager.shared.setupSingIn()
                }
            }
        })
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource,UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavouriteTVCell.self)) as? FavouriteTVCell {
            let request = items[indexPath.row]
            cell.setup(favouriteData: request)
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
        let controller = NavigationManager.shared.detailsScreenVC
        controller.golfCourseDetails = data
        controller.isUpdateTBView = {
            self.lastRequestId = ""
        }
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
                    performGetFavStudios { (flag: Bool) in
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
                    performGetFavStudios { (flag: Bool) in
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
        tblFavourite.separatorStyle = .none
        tblFavourite.separatorColor = .clear
        
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LoadingManager.shared.showLoading()

        self.performGetFavStudios { (flag : Bool) in
            
        }
        NavigationManager.shared.isEnabledBottomMenu = true
    }
    
    //------------------------------------------------------
}
