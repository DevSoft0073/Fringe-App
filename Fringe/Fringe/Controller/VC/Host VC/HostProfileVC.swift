//
//  HostProfileVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 30/08/21.
//

import UIKit
import Foundation

class HostProfileVC : BaseVC {
    
    @IBOutlet weak var tblProfile: UITableView!
    
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
//        tblProfile.delegate = self
//        tblProfile.dataSource = self
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
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
