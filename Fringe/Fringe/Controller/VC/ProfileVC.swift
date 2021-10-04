//
//  ProfileVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 12/08/21.
//

import UIKit
import Alamofire
import Foundation
import CoreLocation

class ProfileVC : BaseVC , UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var tblProfile: UITableView!
    
    var allowPush = String()
    var allowLocation = String()
    
    struct ProfileItems {
        static let accountInformation = LocalizableConstants.Controller.Profile.accountInformation
        static let accountInformationIcon = FGImageName.iconAccountInformation
        static let changePassword = LocalizableConstants.Controller.Profile.changePassword
        static let changePasswordIcon = FGImageName.iconChangePassword
        static let addPayment = LocalizableConstants.Controller.Profile.paymentMethods
        static let addPaymentIcon = FGImageName.iconPaymentMethods
        static let allowLocation = LocalizableConstants.Controller.Profile.allowLocation
        static let allowLocationIcon = FGImageName.iconAllowLocation
        static let allowNotification = LocalizableConstants.Controller.Profile.allowNotification
        static let allowNotificationIcon = FGImageName.iconAllowNotification
        static let myBookings = LocalizableConstants.Controller.Profile.bookingListing
        static let myBookingsIcon = FGImageName.iconBookingListing
        static let switchToBusiness = LocalizableConstants.Controller.Profile.switchToBusiness
        static let signUpToBusiness = LocalizableConstants.Controller.Profile.signUpAsHost
        static let switchToBusinessIcon = FGImageName.iconSwitchToBusiness
        static let termsOfServices = LocalizableConstants.Controller.Profile.termsOfService
        static let termsOfServicesIcon = FGImageName.iconTermsOfService
        static let privacyPolicy = LocalizableConstants.Controller.Profile.privacyPolicy
        static let privacyPolicyIcon = FGImageName.iconPrivacyPolicy
        static let logout = LocalizableConstants.Controller.Profile.logout
        static let logoutIcon = FGImageName.iconLogout
        
    }
    var itemSocials: [ [String:String] ] {
        return [
            ["name": ProfileItems.accountInformation, "image": ProfileItems.accountInformationIcon],
            ["name": ProfileItems.changePassword, "image": ProfileItems.changePasswordIcon],
            ["name": ProfileItems.addPayment, "image": ProfileItems.addPaymentIcon],
            ["name": ProfileItems.allowLocation, "image": ProfileItems.allowLocationIcon],
            ["name": ProfileItems.allowNotification, "image": ProfileItems.allowNotificationIcon],
            ["name": ProfileItems.myBookings, "image": ProfileItems.myBookingsIcon],
//            ["name": PreferenceManager.shared.currentUserModal?.isClubRegistered == true ? ProfileItems.switchToBusiness : ProfileItems.signUpToBusiness, "image": ProfileItems.switchToBusinessIcon],
//            ["name": ProfileItems.switchToBusiness, "image": ProfileItems.switchToBusinessIcon],
            ["name": ProfileItems.termsOfServices, "image": ProfileItems.termsOfServicesIcon],
            ["name": ProfileItems.privacyPolicy, "image": ProfileItems.privacyPolicyIcon],
            ["name": ProfileItems.logout, "image": ProfileItems.logoutIcon]
        ]
    }
    var itemNormal1: [ [String:String] ] {
        return [
            ["name": ProfileItems.accountInformation, "image": ProfileItems.accountInformationIcon],
            ["name": ProfileItems.changePassword, "image": ProfileItems.changePasswordIcon],
            ["name": ProfileItems.addPayment, "image": ProfileItems.addPaymentIcon],
            ["name": ProfileItems.allowLocation, "image": ProfileItems.allowLocationIcon],
            ["name": ProfileItems.allowNotification, "image": ProfileItems.allowNotificationIcon],
            ["name": ProfileItems.myBookings, "image": ProfileItems.myBookingsIcon],
//            ["name": PreferenceManager.shared.currentUserModal?.isClubRegistered == true ? ProfileItems.switchToBusiness : ProfileItems.signUpToBusiness, "image": ProfileItems.switchToBusinessIcon],
            ["name": ProfileItems.switchToBusiness, "image": ProfileItems.switchToBusinessIcon],
            ["name": ProfileItems.termsOfServices, "image": ProfileItems.termsOfServicesIcon],
            ["name": ProfileItems.privacyPolicy, "image": ProfileItems.privacyPolicyIcon],
            //            ["name": ProfileItems.cancellationPolicy, "image": ProfileItems.cancellationPolicyIcon],
            ["name": ProfileItems.logout, "image": ProfileItems.logoutIcon]
        ]
    }
    
    var itemNormal2: [ [String:String] ] {
        return [
            ["name": ProfileItems.accountInformation, "image": ProfileItems.accountInformationIcon],
            ["name": ProfileItems.changePassword, "image": ProfileItems.changePasswordIcon],
            ["name": ProfileItems.addPayment, "image": ProfileItems.addPaymentIcon],
            ["name": ProfileItems.allowLocation, "image": ProfileItems.allowLocationIcon],
            ["name": ProfileItems.allowNotification, "image": ProfileItems.allowNotificationIcon],
            ["name": ProfileItems.myBookings, "image": ProfileItems.myBookingsIcon],
//            ["name": PreferenceManager.shared.currentUserModal?.isClubRegistered == true ? ProfileItems.switchToBusiness : ProfileItems.signUpToBusiness, "image": ProfileItems.switchToBusinessIcon],
            ["name": ProfileItems.signUpToBusiness, "image": ProfileItems.switchToBusinessIcon],
            ["name": ProfileItems.termsOfServices, "image": ProfileItems.termsOfServicesIcon],
            ["name": ProfileItems.privacyPolicy, "image": ProfileItems.privacyPolicyIcon],
            //            ["name": ProfileItems.cancellationPolicy, "image": ProfileItems.cancellationPolicyIcon],
            ["name": ProfileItems.logout, "image": ProfileItems.logoutIcon]
        ]
    }
    
    var items: [ [String: String] ] {
        if currentUser?.isgolfRegistered == "1" {
            return itemNormal1
        }else {
            return itemNormal2
        }
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
        var identifier = String(describing: ProfileTBCell.self)
        var nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblProfile.register(nibProfileCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: ProfileSwitchCell.self)
        nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblProfile.register(nibProfileCell, forCellReuseIdentifier: identifier)
        
    }
    
    func updateUI() {
        
        tblProfile.reloadData()
    }
    
    private func performGetUserProfile(completion:((_ flag: Bool) -> Void)?) {
        
         let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
           ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.profile, parameter: [:], headers: headers, showLoader: false, decodingType: ResponseModal<UserModal>.self, successBlock: { (response: ResponseModal<UserModal>) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                
                if let stringUser = try? response.data?.jsonString() {
                    
                    PreferenceManager.shared.currentUser = stringUser
                    self.setup()
                    self.updateUI()
                }
                delay {
                    completion?(true)
                }
                self.updateUI()
                
            } else {
                
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
                PreferenceManager.shared.userId = nil
                PreferenceManager.shared.currentUser = nil
                PreferenceManager.shared.authToken = nil
                NavigationManager.shared.setupSingIn()
                
                delay {
                    
                    completion?(true)
                    
                }
                
            } else {
                PreferenceManager.shared.userId = nil
                PreferenceManager.shared.currentUser = nil
                PreferenceManager.shared.authToken = nil
                NavigationManager.shared.setupSingIn()
                
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
    
    func chekcAllowLocation() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                if let bundle = Bundle.main.bundleIdentifier,
                   let settings = URL(string: UIApplication.openSettingsURLString + bundle) {
                    DispatchQueue.main.async {
                        if UIApplication.shared.canOpenURL(settings) {
                            UIApplication.shared.open(settings)
                        }
                    }
                }
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
        
    }
    
    func checkAllowPush() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                if let bundle = Bundle.main.bundleIdentifier,
                   let settings = URL(string: UIApplication.openSettingsURLString + bundle) {
                    if UIApplication.shared.canOpenURL(settings) {
                        UIApplication.shared.open(settings)
                    }
                }
                
            } else if settings.authorizationStatus == .denied {
                
                if let bundle = Bundle.main.bundleIdentifier,
                   let settings = URL(string: UIApplication.openSettingsURLString + bundle) {
                    DispatchQueue.main.async {
                        if UIApplication.shared.canOpenURL(settings) {
                            UIApplication.shared.open(settings)
                        }
                    }
                }
                
            } else if settings.authorizationStatus == .authorized {
                print("enable")
            }
        })
    }
    
    private func performAllowLocation(completion:((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
           "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
          ]
        
        let parameter: [String: Any] = [
            Request.Parameter.type: "2" ,
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.allowNotifAndLoc, parameter: parameter, headers: headers, showLoader: false, decodingType: BaseResponseModal.self, successBlock: { (response: BaseResponseModal) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                
                LoadingManager.shared.hideLoading()
                
                delay {
                    
                    DisplayAlertManager.shared.displayAlert(animated: true, message: response.message ?? String())
                    
                    completion?(true)
                    
                }
                
            } else {
                
                LoadingManager.shared.hideLoading()
                
                delay {
                    
                    //                    self.handleError(code: response.code)
                }
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            completion?(false)
            
            delay {
                //                self.handleError(code: error.code)
            }
        })
    }
    
    private func performAllowNotification(completion:((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
           "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
          ]
        
        let parameter: [String: Any] = [
            Request.Parameter.type: "1" ,
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.allowNotifAndLoc, parameter: parameter, headers: headers, showLoader: false, decodingType: BaseResponseModal.self, successBlock: { (response: BaseResponseModal) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                
                LoadingManager.shared.hideLoading()
                
                delay {
                    
                    DisplayAlertManager.shared.displayAlert(animated: true, message: response.message ?? String())
                    
                    completion?(true)
                    
                }
                
            } else {
                
                LoadingManager.shared.hideLoading()
                
                delay {
                    
                    //                    self.handleError(code: response.code)
                }
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            completion?(false)
            
            delay {
                //                self.handleError(code: error.code)
            }
        })
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let name = item["name"]
        let image = item["image"]!
        if name == ProfileItems.allowLocation || name == ProfileItems.allowNotification{
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileSwitchCell.self)) as? ProfileSwitchCell{
                if name == ProfileItems.allowLocation {
                    if currentUser?.allowLocation == "0"
                    {
                        cell.switchPermission.isOn = true
                    }else{
                        cell.switchPermission.isOn = false
                    }
                }else if name == ProfileItems.allowNotification {
                    if currentUser?.allowPush == "0"
                    {
                        cell.switchPermission.isOn = true
                    }else{
                        cell.switchPermission.isOn = false
                    }
                }
                cell.switchPermission.addTarget(self, action: #selector(switchBtnPressed(sender:)), for: .valueChanged)
                cell.switchPermission.tag = indexPath.row
                cell.setup(name: name?.localized())
                
                return cell
            }
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileTBCell.self)) as? ProfileTBCell {
                cell.setup(image: image, name: name?.localized())
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
        
    }
    
    @objc func switchBtnPressed (sender : UISwitch) {
        if sender.tag == 3{
            
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    self.chekcAllowLocation()
                    sender.isOn = false
                case .authorizedAlways, .authorizedWhenInUse:
                    
                    if sender.isOn {
                        allowLocation = "0"
                        performAllowLocation { (flag) in
                        }
                        
                    } else{
                        allowLocation = "1"
                        performAllowLocation { (flag) in
                        }
                    }
                @unknown default:
                    break
                }
            } else {
                sender.isOn = false
                print("Location services are not enabled")
            }
            
        } else {
            
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { (settings) in
                
                DispatchQueue.main.async {
                    if(settings.authorizationStatus == .authorized) {
                        
                        if sender.isOn {
                            self.allowPush = "0"
                            self.performAllowLocation { (flag) in
                            }
                        } else{
                            self.allowPush = "1"
                            self.performAllowNotification { (flag) in
                            }
                        }
                    } else {
                        sender.isOn = false
                        self.checkAllowPush()
                    }
                }
            }
        }
    }
    
    //------------------------------------------------------
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let view: ProfileHeaderView = UIView.fromNib()
        view.setupData(currentUser)
        view.layoutSubviews()
        return view.bounds.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: ProfileHeaderView = UIView.fromNib()
        view.setupData(currentUser)
        view.btnEdit.addTarget(self, action: #selector(showEditDetail), for: .touchUpInside)
        view.layoutSubviews()
        return view
    }
    
    @objc func showEditDetail(){
        let controller = NavigationManager.shared.editProfileVC
        push(controller: controller)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let name = item["name"]
        
        if currentUser?.isgolfRegistered == "0" || currentUser?.isgolfRegistered == "2"{
            
            if name == ProfileItems.accountInformation{
                
                let controller = NavigationManager.shared.accountInformationVC
                controller.textTitle = name?.localized()
                push(controller: controller)
                
            }else if name == ProfileItems.changePassword {
                
                let controller = NavigationManager.shared.changePasswordVC
                controller.textTitle = name?.localized()
                push(controller: controller)
                
            }else if name == ProfileItems.addPayment {
                
                let controller = NavigationManager.shared.addPaymentMethodVC
                push(controller: controller)
                
            }else if name == ProfileItems.myBookings{
                
                let controller = NavigationManager.shared.myBookingVC
                push(controller: controller)
                
            } else if name == ProfileItems.signUpToBusiness{
                if currentUser?.isgolfRegistered == "2" {
                    
                    DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.Error.pendingStripeVerification) {
                        
                    }
                    
                } else if currentUser?.isgolfRegistered == "0"{
                    
                    let controller = NavigationManager.shared.signUpHostVC
                    push(controller: controller)
                }
                
            }else if name == ProfileItems.termsOfServices{
                
                let controller = NavigationManager.shared.serviceTermsVC
                push(controller: controller)
                
            }else if name == ProfileItems.privacyPolicy{
                
                let controller = NavigationManager.shared.privacyVC
                push(controller: controller)
                
            }else if name == ProfileItems.logout {
                
                
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
        } else {
            if name == ProfileItems.accountInformation{
                
                let controller = NavigationManager.shared.accountInformationVC
                controller.textTitle = name?.localized()
                push(controller: controller)
                
            }else if name == ProfileItems.changePassword {
                
                let controller = NavigationManager.shared.changePasswordVC
                controller.textTitle = name?.localized()
                push(controller: controller)
                
            }else if name == ProfileItems.addPayment {
                
                let controller = NavigationManager.shared.addPaymentMethodVC
                push(controller: controller)
                
            }else if name == ProfileItems.myBookings{
                
                let controller = NavigationManager.shared.myBookingVC
                push(controller: controller)
                
            } else if name == ProfileItems.switchToBusiness{
                
                PreferenceManager.shared.curretMode = "2"
                NavigationManager.shared.setupLandingOnHomeForHost()
                
            }else if name == ProfileItems.termsOfServices{
                
                let controller = NavigationManager.shared.serviceTermsVC
                push(controller: controller)
                
            }else if name == ProfileItems.privacyPolicy{
                
                let controller = NavigationManager.shared.privacyVC
                push(controller: controller)
                
            }else if name == ProfileItems.logout {
                
                
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
    }
        
        

    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PreferenceManager.shared.comesFromConfirmToPay = "0"
        setup()
        self.performGetUserProfile { (flag : Bool) in
        }
        NavigationManager.shared.isEnabledBottomMenu = true
    }
    
    //------------------------------------------------------
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
}
