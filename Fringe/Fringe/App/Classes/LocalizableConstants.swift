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
        static let enterFirstName = "enter_first_name"
        static let enterValidEmail = "enter_valid_email"
        static let enterMobileNumber = "enter_mobile"
        static let enterValidMobileNumber = "enter_valid_mobile"
        static let enterHomeTown = "enter_home_town"
        static let enterProffession = "enter_proffession"
        static let enterMemberCousre = "enter_member_course"
        static let enterGolfHandicap = "enter_golf_handicap"
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
        struct Notifications {
            
            static let title = "notifications"
            static let noRecordsFound = "no_notifications_entry_found"
        }
        struct Fringe {
            
            static let title = "sessions"
            static let pending = "pending"
            static let confirmed = "confirmed"
            static let moreInfo = "more_info"
            static let payNow = "pay_now"
        }
        struct FringeDataForGolfclub {
            
            static let pending = "no_pending_data_found"
            static let awating = "no_awating_data_found"
            static let confirmed = "no_confirmed_data_found"
            static let noSelected = "no_session_selected"
            static let calendar = "no_data_available_for_this_date"
            static let blockedDates = "seleceted_dates_are_already_blocked"
            static let noDateBlocked = "no_date_blocked_for_this_month"
        }
        struct Profile {
            
            static let accountInformation = "account_information"
            static let changePassword = "change_password"
            static let paymentMethods = "payment_method"
            static let allowLocation = "allow_location"
            static let allowNotification = "allow_notification"
            static let bookingListing = "my_bookings"
            static let switchToBusiness = "switch_to_business"
            static let termsOfService = "terms_of_service"
            static let privacyPolicy = "Privacy"
            static let logout = "sign_out"
        }
    }
}
