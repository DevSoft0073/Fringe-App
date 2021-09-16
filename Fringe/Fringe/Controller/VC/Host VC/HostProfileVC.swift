//
//  HostProfileVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 30/08/21.
//

import UIKit
import Foundation
import Alamofire

class HostProfileVC : BaseVC, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblProfile: UITableView!
    
    var section = ["","",""]
    
    struct ProfileItems {
        static let accountInformation = LocalizableConstants.Controller.HostProfile.accountInformation
        static let accountInformationIcon = FGImageName.iconAccountInformation
        static let changePassword = LocalizableConstants.Controller.HostProfile.changePassword
        static let changePasswordIcon = FGImageName.iconChangePassword
        static let addPayment = LocalizableConstants.Controller.HostProfile.paymentMethods
        static let addPaymentIcon = FGImageName.iconPaymentMethods
        static let allowLocation = LocalizableConstants.Controller.HostProfile.allowLocation
        static let allowLocationIcon = FGImageName.iconAllowLocation
        static let allowNotification = LocalizableConstants.Controller.HostProfile.allowNotification
        static let allowNotificationIcon = FGImageName.iconAllowNotification
        static let switchToPlayer = LocalizableConstants.Controller.HostProfile.switchToPlayer
        static let switchToBusinessIcon = FGImageName.iconSwitchToBusiness
        static let termsOfServices = LocalizableConstants.Controller.HostProfile.termsOfService
        static let termsOfServicesIcon = FGImageName.iconTermsOfService
        static let privacyPolicy = LocalizableConstants.Controller.HostProfile.privacyPolicy
        static let privacyPolicyIcon = FGImageName.iconPrivacyPolicy
        static let logout = LocalizableConstants.Controller.HostProfile.logout
        static let logoutIcon = FGImageName.iconLogout
        
    }
    
    var itemSocials: [ [String:String] ] {
        return [
            ["name": ProfileItems.accountInformation, "image": ProfileItems.accountInformationIcon],
            ["name": ProfileItems.changePassword, "image": ProfileItems.changePasswordIcon],
            ["name": ProfileItems.addPayment, "image": ProfileItems.addPaymentIcon],
            ["name": ProfileItems.allowLocation, "image": ProfileItems.allowLocationIcon],
            ["name": ProfileItems.allowNotification, "image": ProfileItems.allowNotificationIcon],
            
            //            ["name": PreferenceManager.shared.currentUserModal?.isStudioRegistered == true ? ProfileItems.switchToStudioProfile : ProfileItems.signupToStudioProfile, "image": ProfileItems.switchToStudioProfileIcon],
            ["name": ProfileItems.switchToPlayer, "image": ProfileItems.switchToBusinessIcon],
            ["name": ProfileItems.termsOfServices, "image": ProfileItems.termsOfServicesIcon],
            ["name": ProfileItems.privacyPolicy, "image": ProfileItems.privacyPolicyIcon],
            //            ["name": ProfileItems.cancellationPolicy, "image": ProfileItems.cancellationPolicyIcon],
            ["name": ProfileItems.logout, "image": ProfileItems.logoutIcon]
        ]
    }
    var itemNormal: [ [String:String] ] {
        return [
            ["name": ProfileItems.accountInformation, "image": ProfileItems.accountInformationIcon],
            ["name": ProfileItems.changePassword, "image": ProfileItems.changePasswordIcon],
            ["name": ProfileItems.addPayment, "image": ProfileItems.addPaymentIcon],
            ["name": ProfileItems.allowLocation, "image": ProfileItems.allowLocationIcon],
            ["name": ProfileItems.allowNotification, "image": ProfileItems.allowNotificationIcon],
            
            //            ["name": PreferenceManager.shared.currentUserModal?.isStudioRegistered == true ? ProfileItems.switchToStudioProfile : ProfileItems.signupToStudioProfile, "image": ProfileItems.switchToStudioProfileIcon],
            ["name": ProfileItems.switchToPlayer, "image": ProfileItems.switchToBusinessIcon],
            ["name": ProfileItems.termsOfServices, "image": ProfileItems.termsOfServicesIcon],
            ["name": ProfileItems.privacyPolicy, "image": ProfileItems.privacyPolicyIcon],
            //            ["name": ProfileItems.cancellationPolicy, "image": ProfileItems.cancellationPolicyIcon],
            ["name": ProfileItems.logout, "image": ProfileItems.logoutIcon]
        ]
    }
    var items: [ [String: String] ] {
        
        return itemNormal
    }
    
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
        tblProfile.delegate = self
        tblProfile.dataSource = self
        var identifier = String(describing: HostProfileTBCell.self)
        var nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblProfile.register(nibProfileCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: HostProfileSwitchCell.self)
        nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblProfile.register(nibProfileCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: ShowImagesCell.self)
        nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblProfile.register(nibProfileCell, forCellReuseIdentifier: identifier)
        
        updateUI()
        
    }
    func updateUI() {
        
        tblProfile.reloadData()
    }
    
    private func performGetUserProfile(completion:((_ flag: Bool) -> Void)?) {
        
         let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
           ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.hostProfile, parameter: [:], headers: headers, showLoader: false, decodingType: ResponseModal<HostModal>.self, successBlock: { (response: ResponseModal<HostModal>) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                
                if let stringUser = try? response.data?.jsonString() {
                    
                    PreferenceManager.shared.currentUserHost = stringUser
                    self.setup()
                    self.updateUI()
                }
                delay {
                    completion?(true)
                }
                self.updateUI()
                
            } else {
                
                delay {
                                            
                    DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: response.message ?? String()) {
                          
                    }
                }
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
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
    
    private func performSignOut(completion:((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
           "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
          ]
       
        RequestManager.shared.requestPOST(requestMethod: Request.Method.logout, parameter: [:], headers: headers, showLoader: false, decodingType: BaseResponseModal.self, successBlock: { (response: BaseResponseModal) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                
                PreferenceManager.shared.loggedUser = false
                
                LoadingManager.shared.hideLoading()
                
                delay {
                    
                    completion?(true)
                    
                }
                
            } else {
                
                LoadingManager.shared.hideLoading()
                
                delay {
                }
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
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
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        } else if section == 1 {
            return items.count
        } else if section == 2 {
            return 0
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowImagesCell.self)) as? ShowImagesCell {
                cell.setup(images: currentUserHost?.golfImages ?? [])
                return cell
            }
            
        }else if indexPath.section == 1{
            let item = itemNormal[indexPath.row]
            let name = item["name"]
            let image = item["image"]!
            
            if name == ProfileItems.allowLocation || name == ProfileItems.allowNotification {
                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HostProfileSwitchCell.self)) as? HostProfileSwitchCell {
                    
                    if name == ProfileItems.allowLocation {
                        if currentUser?.allowLocation == "0"{
                            cell.switchPermission.isOn = true
                        }else{
                            cell.switchPermission.isOn = false
                        }
                    }else if name == ProfileItems.allowNotification {
                        if currentUser?.allowPush == "0"{
                            cell.switchPermission.isOn = true
                        }else{
                            cell.switchPermission.isOn = false
                        }
                    }
                    //                    cell.switchPermission.addTarget(self, action: #selector(switchBtnPressed(sender:)), for: .valueChanged)
                    cell.switchPermission.tag = indexPath.row
                    cell.setup( name: name?.localized())
                    return cell
                }
            }else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HostProfileTBCell.self)) as? HostProfileTBCell {
                    cell.setup(image: image, name: name?.localized())
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
            let view: HostProfileHeaderView = UIView.fromNib()
            view.setupData(currentUser)
            view.layoutSubviews()
            return view.bounds.height
            
        } else if section == 1 {
            let view: ProfileViewForTitle = UIView.fromNib()
//            view.titleLbl.text = "GALLERY IMAGES"
            view.layoutSubviews()
            return 0
            
        }else if section == 2 {
            let view: ProfileViewForTitle = UIView.fromNib()
            view.titleLbl.text = "GALLERY IMAGES"
            view.layoutSubviews()
            return view.bounds.height
            
        }
        return view.bounds.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let view: HostProfileHeaderView = UIView.fromNib()
            view.setupData(currentUser)
            view.btnEdit.addTarget(self, action: #selector(showEditDetail), for: .touchUpInside)
            view.layoutSubviews()
            return view
            
        } else if section == 1 {
            let view: ProfileViewForTitle = UIView.fromNib()
//            view.titleLbl.text = "GALLERY IMAGES"
            view.layoutSubviews()
            return view
            
        } else if section == 2 {
            let view: ProfileViewForTitle = UIView.fromNib()
            view.titleLbl.text = "GALLERY IMAGES"
            view.layoutSubviews()
            return view
            
        }
        return view
    }
    
    @objc func showEditDetail(){
        let controller = NavigationManager.shared.hostEditProfileVC
        push(controller: controller)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 65
        }else {
            return 170
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let name = item["name"]
        if name == ProfileItems.accountInformation{
            
            let controller = NavigationManager.shared.hostAccountInformationVC
            controller.textTitle = name?.localized()
            push(controller: controller)
            
        }else if name == ProfileItems.changePassword {
            
            let controller = NavigationManager.shared.changePasswordVC
            controller.textTitle = name?.localized()
            push(controller: controller)
            
        }else if name == ProfileItems.addPayment {
            
            let controller = NavigationManager.shared.hostAddPaymentMethodVC
            push(controller: controller)
            
        }else if name == ProfileItems.switchToPlayer{
            
            NavigationManager.shared.setupLandingOnHome()
//            let controller = NavigationManager.shared.signUpHostVC
//            push(controller: controller)
            
        }else if name == ProfileItems.termsOfServices{
            
            let controller = NavigationManager.shared.serviceTermsVC
            push(controller: controller)
            
        }else if name == ProfileItems.privacyPolicy{
            
            let controller = NavigationManager.shared.privacyVC
            push(controller: controller)
            
        } else if name == ProfileItems.logout {
            
            DisplayAlertManager.shared.displayAlertWithNoYes(target: self, animated: true, message: LocalizableConstants.ValidationMessage.confirmLogout.localized()) {
                
                //Nothing to handle
                
            } handlerYes: {
                
                LoadingManager.shared.showLoading()
                
                delayInLoading {
                    
                    LoadingManager.shared.hideLoading()
                    self.performSignOut { (flag: Bool) in
                        if flag {
                            PreferenceManager.shared.currentUser = nil
                            PreferenceManager.shared.loggedUser = false
                            NavigationManager.shared.setupSingIn()
                        }
                    }
                }
            }            
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblProfile.separatorStyle = .none
        tblProfile.separatorColor = .clear
        setup()
        self.performGetUserProfile { (flag : Bool) in
            
        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenuForHost = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    //------------------------------------------------------
}
