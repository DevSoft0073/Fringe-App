//
//  ProfileVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 12/08/21.
//

import UIKit
import Foundation

class ProfileVC : BaseVC , UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var tblProfile: UITableView!
    
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
//            ["name": PreferenceManager.shared.currentUserModal?.isStudioRegistered == true ? ProfileItems.switchToStudioProfile : ProfileItems.signupToStudioProfile, "image": ProfileItems.switchToStudioProfileIcon],
            ["name": ProfileItems.switchToBusiness, "image": ProfileItems.switchToBusinessIcon],
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
            ["name": ProfileItems.myBookings, "image": ProfileItems.myBookingsIcon],
//            ["name": PreferenceManager.shared.currentUserModal?.isStudioRegistered == true ? ProfileItems.switchToStudioProfile : ProfileItems.signupToStudioProfile, "image": ProfileItems.switchToStudioProfileIcon],
            ["name": ProfileItems.switchToBusiness, "image": ProfileItems.switchToBusinessIcon],
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
//                if name == ProfileItems.allowLocation {
////                    if currentUser?.allowLocation == "0"
//                    {
////                        cell.switchPermission.isOn = true
//                    }else{
////                        cell.switchPermission.isOn = false
//                    }
//                }else if name == ProfileItems.allowNotification {
////                    if currentUser?.allowPush == "0"
//                    {
////                        cell.switchPermission.isOn = true
//                    }else{
////                        cell.switchPermission.isOn = false
//                    }
//                }
//                cell.switchPermission.addTarget(self, action: #selector(switchBtnPressed(sender:)), for: .valueChanged)
//                cell.switchPermission.tag = indexPath.row
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
    
    //------------------------------------------------------
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let view: ProfileHeaderView = UIView.fromNib()
//        view.setupData(currentUser)
        view.layoutSubviews()
        return view.bounds.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: ProfileHeaderView = UIView.fromNib()
//        view.setupData(currentUser)
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
         }else if name == ProfileItems.switchToBusiness{
            let controller = NavigationManager.shared.signUpHostVC
                        push(controller: controller)
         }
        
    }
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        
        NavigationManager.shared.isEnabledBottomMenu = true
    }
    
    //------------------------------------------------------
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
}
