//
//  PreferenceManager.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import UIKit
import AssistantKit

class PreferenceManager: NSObject {

    public static var shared = PreferenceManager()
    private let userDefault = UserDefaults.standard
       
    //------------------------------------------------------
    
    //MARK: Settings
    
    var userBaseURL: String {
        return "https://www.dharmani.com/fringe/webservices"
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    private let keyDeviceToken = "deviceToken"
    private let keyUserId = "userId"
    private let keyUserData = "keyUserData"
    private let keyLoggedUser = "keyLoggedUser"
    private let keyLat = "lat"
    private let keyLong = "long"
    private let keyAuth = "auth"
    private let keyUserDataForHost = "keyUserDataForHost"
    private let currentMode = "currentMode"
    private let golfID = "golfID"
    private let comesFromPay = "comesFromPay"
    private let comesFromListing = "comesFromListing"
    private let comesFromPopView = "comesFromPopUpView"
    private let isHostUser = "isHostUser"
    private let badgeData = "badgeData"

    var deviceToken: String? {
        set {
            if newValue != nil {
                userDefault.set(newValue!, forKey: keyDeviceToken)
            } else {
                userDefault.removeObject(forKey: keyDeviceToken)
            }
            userDefault.synchronize()
        }
        get {
            let token = userDefault.string(forKey: keyDeviceToken)
            if token?.isEmpty == true || token == nil {
                return Device.versionCode
            } else {
                return userDefault.string(forKey: keyDeviceToken)
            }            
        }
    }

    var userId: String? {
        set {
            if newValue != nil {
                userDefault.set(newValue!, forKey: keyUserId)
            } else {
                userDefault.removeObject(forKey: keyUserId)
            }
            userDefault.synchronize()
        }
        get {            
            return userDefault.string(forKey: keyUserId)
        }
    }
    
    var authToken: String? {
        set {
            if newValue != nil {
                userDefault.set(newValue!, forKey: keyAuth)
            } else {
                userDefault.removeObject(forKey: keyAuth)
            }
            userDefault.synchronize()
        }
        get {
            return userDefault.string(forKey: keyAuth)
        }
    }
    
    var currentUser: String? {
        set {
            if newValue != nil {
                userDefault.set(newValue!, forKey: keyUserData)
            } else {
                userDefault.removeObject(forKey: keyUserData)
            }
            userDefault.synchronize()
        }
        get {
            return userDefault.string(forKey: keyUserData)
        }
    }
    
    var currentUserHost: String? {
        set {
            if newValue != nil {
                userDefault.set(newValue!, forKey: keyUserDataForHost)
            } else {
                userDefault.removeObject(forKey: keyUserDataForHost)
            }
            userDefault.synchronize()
        }
        get {
            return userDefault.string(forKey: keyUserDataForHost)
        }
    }
    
    var badgeModal: String? {
        set {
            if newValue != nil {
                userDefault.set(newValue!, forKey: badgeData)
            } else {
                userDefault.removeObject(forKey: badgeData)
            }
            userDefault.synchronize()
        }
        get {
            return userDefault.string(forKey: badgeData)
        }
    }
    
    var badgeModalData: BadgeModal? {
        if let badgeModal = badgeModal {
            do {
                return try BadgeModal(badgeModal)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
        return nil
    }
    
    var currentUserModalForHost: HostModal? {
        if let currentUserHost = currentUserHost {
            do {
                return try HostModal(currentUserHost)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
        return nil
    }
    
    var currentUserModal: UserModal? {
        if let currentUser = currentUser {
            do {
                return try UserModal(currentUser)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
        return nil
    }
    
    var loggedUser: Bool {
        set {
            userDefault.set(newValue, forKey: keyLoggedUser)
            userDefault.synchronize()
        }
        get {
            return userDefault.bool(forKey: keyLoggedUser)
        }
    }
    
    var lat: Double? {
        set {
            if newValue != nil {
                userDefault.set(newValue!, forKey: keyLat)
            } else {
                userDefault.removeObject(forKey: keyLat)
            }
            userDefault.synchronize()
        }
        get {
            return userDefault.double(forKey: keyLat)
        }
    }
    
    var long: Double? {
        set {
            if newValue != nil {
                userDefault.set(newValue!, forKey: keyLong)
            } else {
                userDefault.removeObject(forKey: keyLong)
            }
            userDefault.synchronize()
        }
        get {
            return userDefault.double(forKey: keyLong)
        }
    }
    
    var curretMode: String? {
        set {
            if newValue != nil {
                userDefault.set(newValue!, forKey: currentMode)
            } else {
                userDefault.removeObject(forKey: currentMode)
            }
            userDefault.synchronize()
        }
        get {
            return userDefault.string(forKey: currentMode)
        }
    }
    
    var golfId: String? {
        set {
            if newValue != nil {
                userDefault.set(newValue!, forKey: golfID)
            } else {
                userDefault.removeObject(forKey: golfID)
            }
            userDefault.synchronize()
        }
        get {
            return userDefault.string(forKey: golfID)
        }
    }
    
    var comesFromConfirmToPay: String? {
        set {
            if newValue != nil {
                userDefault.set(newValue!, forKey: comesFromPay)
            } else {
                userDefault.removeObject(forKey: comesFromPay)
            }
            userDefault.synchronize()
        }
        get {
            return userDefault.string(forKey: comesFromPay)
        }
    }

    var comesFromHomeListing: Bool {
        set {
            userDefault.set(newValue, forKey: comesFromListing)
            userDefault.synchronize()
        }
        get {
            return userDefault.bool(forKey: comesFromListing)
        }
    }
    
    var comesFromPopUpView: Bool {
        set {
            userDefault.set(newValue, forKey: comesFromPopView)
            userDefault.synchronize()
        }
        get {
            return userDefault.bool(forKey: comesFromPopView)
        }
    }
    
    var isHost: String? {
        set {
            if newValue != nil {
                userDefault.set(newValue!, forKey: isHostUser)
            } else {
                userDefault.removeObject(forKey: isHostUser)
            }
            userDefault.synchronize()
        }
        get {
            return userDefault.string(forKey: isHostUser)
        }
    }
    
    //------------------------------------------------------
}

