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
    static let profileImageSize = CGSize.init(width: 400, height: 400)
    static let profileBorderWidth: CGFloat = 4    
}

struct FGColor {
    
    static let appBorder = UIColor(named: "appBorder")!
    static let appButton = UIColor(named: "appButton")!
    static let appGreen = UIColor(named: "appGreen")!
    static let appWhite = UIColor(named: "appWhite")!
    static let appBlack = UIColor(named: "appBlack")!
    static let appBackground = UIColor(named: "appBackground")!
    static let appDarkBlack = UIColor(named: "appDarkBlack")!
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
    static let iconOpenEye = "eye_open"
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
    static let iconPlaceHolder = "placeholder-image"
    
    static let iconFavouriteSelected = "favourite_sel"
    static let iconGolfSelected = "golf_sel"
    static let iconHomeSelected = "home_sel"
    static let iconInboxSelected = "inbox_sel"
    static let iconProfileSelected = "profile_sel"
    static let iconNotificationSelected = "notification_sel"
    static let iconCalendarSelected = "calendar_sel"
    static let iconFavouriteUnselected = "favourite_unsel"
    static let iconGolfUnselected = "golf_unsel"
    static let iconHomeUnselected = "home_unsel"
    static let iconInboxUnselected = "inbox_unsel"
    static let iconProfileUnselected = "profile_unsel"
    static let iconNotificationUnselected = "notification_unsel"
    static let iconCalendarUnselected = "calendar_unsel"
    static let icontransparent = "icon_transparent"
    static let iconRight = "right_icon"
    static let iconLeft = "left_icon"
    
    // Profile
    
    static let iconEditProfile = "edit_profile"
    static let iconAccountInformation = "account_info"
    static let iconPaymentMethods = "add_payment"
    static let iconChangePassword = "change_password"
    static let iconAllowLocation = "icon_allow_location"
    static let iconAllowNotification = "icon_allow_notification"
    static let iconBookingListing = "my_booking"
    static let iconSwitchToBusiness = "switch_host"
    static let iconTermsOfService = "terms_service"
    static let iconPrivacyPolicy = "privacy_policy"
    static let iconLogout = "logout"
    
    // Add Payment
    
    static let iconApplePayment = "apple_payment"
    static let iconCreditCardPayment = "card_payment"
    static let iconPayPayment = "pay_payment"
    static let iconDropDwn = "drop_down"
    static let iconDropRight = "right"
    
    // Rating star
    
    static let iconSelectedStar = "rating"
    static let iconUnselectedStar = "star"
    
    // details screen
    
    static let iconWhiteBack = "white_back"
    static let iconWhiteHeart = "white_heart"
    static let iconUnFavWhiteHeart = "un_fav"
    static let iconUpload = "upload"
    
    // payment cards
    
    static let iconAmericanExpress = "amex"
    static let iconMaestro = "Maestro"
    static let iconMastercard = "mastercard"
    static let iconUnionpay = "unionpay"
    static let iconVisa = "visa"
    
    // SignupHost
    
    static let iconSignClose = "sign_close"
    static let iconSignPlus = "sign_plus"
    static let iconSignAdd = "sign_add"
    
    // PopUp
    static let iconPopImage = "Popup"
    static let iconPlusWhite = "plus_white"
    static let iconPlus = "plus"
    static let iconPlusHost =  "plus_host"
    static let iconPlusSelected = "plusSel"
    static let iconSub = "sub"
    static let iconSubSelected = "subsel"
    static let iconFeedback = "feedback"
    static let iconRadio = "radio"
    static let iconRadioUnselect = "radioun"
    
}

struct FGScreenName {
      
    static let subscribed = "subscribed"
    static let home = "home"
    static let settings = "settings"
}
