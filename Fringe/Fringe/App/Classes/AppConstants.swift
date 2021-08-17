//
//  AppConstants.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import UIKit

let kAppName : String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? String()
let kAppBundleIdentifier : String = Bundle.main.bundleIdentifier ?? String()

enum DeviceType: String {
    case iOS = "iOS"
    case android = "android"
}

let emptyJsonString = "{}"

struct FGSettings {
    
    static let cornerRadius: CGFloat = 3
    static let borderWidth: CGFloat = 1
    static let shadowOpacity: Float = 0.4
    static let tableViewMargin: CGFloat = 50
    
    static let nameLimit = 20
    static let emailLimit = 70
    static let passwordLimit = 20
    
    static let footerMargin: CGFloat = 50
}

struct FGColor {
    
    static let appBorder = UIColor(named: "appBorder")!
    static let appButton = UIColor(named: "appButton")!
    static let appGreen = UIColor(named: "appGreen")!
    static let appWhite = UIColor(named: "appWhite")!
    static let appBackground = UIColor(named: "appBackground")!
//    static let darkGray = UIColor.darkGray
//    static let clear = UIColor.clear
}

struct FGFont {
    
    static let defaultRegularFontSize: CGFloat = 20.0
    static let zero: CGFloat = 0.0
    static let reduceSize: CGFloat = 3.0
    static let increaseSize : CGFloat = 2.0
    
    //"family: Poppins "
    static func PoppinsBold(size: CGFloat?) -> UIFont {
        return UIFont(name: "Poppins-Bold", size: size ?? defaultRegularFontSize)!
    }
    static func PoppinsLight(size: CGFloat?) -> UIFont {
        return UIFont(name: "Poppins-Light", size: size ?? defaultRegularFontSize)!
    }
    static func PoppinsMedium(size: CGFloat?) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: size ?? defaultRegularFontSize)!
    }
    static func PoppinsRegular(size: CGFloat?) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: size ?? defaultRegularFontSize)!
    }
    static func PoppinsSemiBold(size: CGFloat?) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: size ?? defaultRegularFontSize)!
    }
}

struct FGImageName {

    static let iconDropDown = "drop"
    static let iconApple = "apple"
    static let iconEye = "eye"
    static let iconFaceBook = "face"
    static let iconGoogle = "google"
    static let iconCalender = "cal"
    static let iconCamera = "cam"
    static let iconProfile = "pf"
    static let iconSplashBackGround = "splash_img"
    static let iconSplashLogo = "splash"
    static let iconBack = "back"
    static let iconCheck = "check"
    static let iconUncheck = "uncheck"
    
    static let iconFavouriteSelected = "favourite_sel"
    static let iconGolfSelected = "golf_sel"
    static let iconHomeSelected = "home_sel"
    static let iconInboxSelected = "inbox_sel"
    static let iconProfileSelected = "profile_sel"
    static let iconFavouriteUnselected = "favourite_unsel"
    static let iconGolfUnselected = "golf_unsel"
    static let iconHomeUnselected = "home_unsel"
    static let iconInboxUnselected = "inbox_unsel"
    static let iconProfileUnselected = "profile_unsel"
    static let icontransparent = "icon_transparent"
    
   
    static let iconAccountInformation = "icon_info"
    static let iconPaymentMethods = "icon_payment_method"
    static let iconChangePassword = "icon_change_password"
    static let iconAllowLocation = "icon_allow_location"
    static let iconAllowNotification = "icon_allow_notification"
    static let iconBookingListing = "icon_bookings"
    static let iconSwitchToBusiness = "icon_business"
    static let iconTermsOfService = "icon_terms_of_service"
    static let iconPrivacyPolicy = "icon_policy"
    static let iconLogout = "icon_sign_out"
}

struct FGScreenName {
      
    static let subscribed = "subscribed"
    static let home = "home"
    static let settings = "settings"
}
