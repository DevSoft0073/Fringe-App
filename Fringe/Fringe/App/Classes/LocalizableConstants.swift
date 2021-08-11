//
//  LocalizableConstant.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import UIKit

struct LocalizableConstants {
    
    struct SuccessMessage {
        static let verificationMailSent = "verification_mail_sent"
        static let mailNotVerifiedYet = "mail_not_verified_yet"
        static let newPasswordSent = "new_password_sent"
        static let profileUpdated = "profile_updated"
        static let passwordChanged = "password_changed"
        static let addRequestSent = "add_request_sent"
        static let addRemoveFavUnfavStudio = "add_remove_fav_Unfav_studio"
        static let cancellationRequestSubmit = "your_cancellation_request_submit"
        static let rejectRequestSubmit = "your_rejection_request_submit"
        static let requestAccept = "your_request_submitted"
        static let timeSlotAdded = "time_slot_added"
        static let addedCard = "added_card_details"
        static let submitFeedback = "feedback_submit"
        static let blokDay = "blok_day"
    }
    
    struct Error {
        
        static let noNetworkConnection = "no_network_connection"
        static let sessionExpired = "session_expired"
        static let inProgress = "in_progress"
        static let cardDetailsNotValid = "please_enter_valid_card_details"
        static let accountDisable = "your_account_has_been_disable_please_contact_with_admin_for_more_detail"
        static let pendingStripeVerification = "pending_verification"
        static let maximumLimit = "add_limit"
    }
    
    struct ValidationMessage {
        
        //signup
        static let enterUserName = "enter_user_name"
        static let enterLastName = "enter_last_name"
        static let selectBirthDate = "select_birth_date"
        static let selectGender = "select_gender"
        static let enterEmail = "enter_email"
        static let enterValidEmail = "enter_valid_email"
        static let enterMobileNumber = "enter_mobile"
        static let enterValidMobileNumber = "enter_valid_mobile"
        static let enterHomeTown = "enter_home_town"
        static let enterProffession = "enter_proffession"
        static let enterMemberCousre = "enter_member_course"
        static let enterGolfHandicap = ""
        static let enterPassword = "enter_password"
        static let enterValidPassword = "enter_valid_password"
        static let agreeTermsAndConditions = "agree_with_terms_and_conditions"
        static let ageMustBeGreaterThen13 = "age_should_be_greater_then_13"
        
        //change password
        static let enterNewPassword = "enter_new_password"
        static let enterValidNewPassword = "enter_valid_new_password"
        static let enterRetypePassword = "enter_confirm_password"
        static let enterValidRetypePassword = "enter_valid_confirm_password"
        static let oldNewPasswordNotSame = "old_new_password_not_same"
        static let NewRetypePasswordNotMatch = "new_retype_password_not_match"
        
        //add request
        static let enterName = "enter_name"
        static let selectAddRequestPhoto = "select_add_request_photo"
        
        //signout
        static let confirmLogout = "confirm_logout"
        
    }
    
    struct Controller {
    }
}