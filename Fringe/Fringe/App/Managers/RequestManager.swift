
//
//  RequestManager.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import UIKit
import Alamofire

struct Request {
    
    struct Parameter {
        
        static let id = "id"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let email = "email"
        static let password = "password"
        static let deviceToken = "device_token"
        static let deviceType = "device_type" //ios/android
        static let userID = "user_id"
        
        // Sign up as player
        
        static let fullName = "user_name"
        static let dob = "dob"
        static let gender = "gender"
        static let mobileNumber = "mobile_no"
        static let homeTown = "hometown"
        static let profession = "profession"
        static let memberCourse = "member_course"
        static let golfHandicap = "golf_handicap"
        static let confirmPassword = "confirm_password"
        static let timeZone = "time_zone"
        static let lat = "latitude"
        static let long = "longitude"
        static let appleToken = "apple_token"
        
        // chnage password
        static let newPassword = "new_password"
        static let oldPassword = "old_password"
    }
    
    struct Method {
        
        static let signup = "/SignUp.php"
        static let login = "/Login.php"
        static let aLogin = "/appleLogin.php"
        static let edit = "/editProfile.php"
        static let changePassword = "/ChangePassword.php"
    }
    
}

class RequestManager: NSObject {
    
    static var shared = RequestManager()
    
    fileprivate var isReachable: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    public var isSessionExpired: Bool = false
    
    //------------------------------------------------------
    
    //MARK: Background Task
    
    var backgroundTask = UIBackgroundTaskIdentifier.invalid
    
    fileprivate func backgroundFetch(_ requestMethod: String) {
        let app = UIApplication.shared
        let endBackgroundTask = {
            if self.backgroundTask != UIBackgroundTaskIdentifier.invalid {
                app.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = UIBackgroundTaskIdentifier.invalid
            }
        }
        backgroundTask = app.beginBackgroundTask(withName: String(format: "%@.%@", kAppBundleIdentifier, requestMethod)) {
            endBackgroundTask()
        }
    }
    
    //------------------------------------------------------
    
    //MARK: GENERAL
    
    fileprivate func requestREST<T: Decodable>(type: HTTPMethod, requestMethod : String, parameter : [String : Any], header : [String:Any],showLoader : Bool, decodingType: T.Type, successBlock:@escaping (( _ response: T)->Void), failureBlock:@escaping (( _ error : ErrorModal) -> Void)) {
        
        guard isReachable == true else {
            LoadingManager.shared.hideLoading()
            delay {
                LoadingManager.shared.showError(message: LocalizableConstants.Error.noNetworkConnection)
            }
            return
        }
        
        var requestURL: String = String()
        var headers: HTTPHeaders = [:]
        headers["content-type"] = "application/json"
        /*if type == .post {
         headers["content-type"] = "application/x-www-form-urlencoded"
         }*/
        requestURL = PreferenceManager.shared.userBaseURL.appending(requestMethod)
        
        debugPrint("----------- \(requestMethod) ---------")
        debugPrint("requestURL:\(requestURL)")
        debugPrint("requestHeader:\(headers)")
        print("parameter:\(parameter.dict2json())")
        
        if showLoader == true {
            LoadingManager.shared.showLoading()
        }
        
        backgroundFetch(requestMethod)
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 60
        
        let encodingType: ParameterEncoding = (type == HTTPMethod.post) ? JSONEncoding.default : URLEncoding.default
        request(requestURL, method: type, parameters: parameter, encoding: encodingType, headers: headers).responseData { (response: DataResponse<Data>) in
            switch response.result {
            case .success:
                if showLoader == true {
                    LoadingManager.shared.hideLoading()
                }
                if let jsonData = response.result.value {
                    do {
                        let responseString = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
                        print(".success:\(String(describing: responseString?.dict2json()))")
                        debugPrint("--------------------")
                        if response.response?.statusCode == Status.Code.success {
                            if jsonData.count > 0 {
                                let result = try JSONDecoder().decode(decodingType, from: jsonData)
                                successBlock(result)
                            } else {
                                let emptyData = try JSONSerialization.data(withJSONObject: [:], options: [])
                                let result = try JSONDecoder().decode(decodingType, from: emptyData)
                                successBlock(result)
                            }
                        } else {
                            let emptyData = try JSONSerialization.data(withJSONObject: [:], options: [])
                            let result = try JSONDecoder().decode(decodingType, from: emptyData)
                            successBlock(result)
                        }
                    } catch let error {
                        debugPrint(".failure:\(error.localizedDescription)")
                        debugPrint("--------------------")
                        let errorModal = ErrorModal(code: error._code, errorDescription: error.localizedDescription)
                        failureBlock(errorModal)
                    }
                }
                break
            case .failure(let error):
                
                if showLoader == true {
                    LoadingManager.shared.hideLoading()
                }
                debugPrint(".failure:\(error.localizedDescription)")
                debugPrint("--------------------")
                let errorModal = ErrorModal(code: error._code, errorDescription: error.localizedDescription)
                failureBlock(errorModal)
                break
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: GET
    
    func requestGET<T: Decodable>(requestMethod : String, parameter : [String : Any],header : [String : Any], showLoader : Bool, decodingType: T.Type, successBlock:@escaping (( _ response: T)->Void), failureBlock:@escaping (( _ error : ErrorModal) -> Void)) {
        
        requestREST(type: HTTPMethod.get, requestMethod: requestMethod, parameter: parameter, header: header, showLoader: showLoader, decodingType: decodingType, successBlock: { (response: T) in
            
            successBlock(response)
            
        }, failureBlock: { (error: ErrorModal) in
            
            failureBlock(error)
        })
    }
    
    //------------------------------------------------------
    
    //MARK: POST
    
    func requestPOST<T: Decodable>(requestMethod : String, parameter : [String : Any], headers : [String : Any]? = nil, showLoader : Bool, decodingType: T.Type, successBlock:@escaping (( _ response: T)->Void), failureBlock:@escaping (( _ error : ErrorModal) -> Void)) {
        
        requestREST(type: HTTPMethod.post, requestMethod: requestMethod, parameter: parameter, header: headers ?? [:], showLoader: showLoader, decodingType: decodingType, successBlock: { (response: T) in
            
            successBlock(response)
            
        }, failureBlock: { (error: ErrorModal) in
            
            failureBlock(error)
        })
    }
    
    //------------------------------------------------------
    
    //MARK: Form Data
    
    func multipartImageRequest( parameter: Parameters, imagesData:[String: Data] = [String: Data](), profileImagesData:[String: Data] = [String: Data]() , keyName : String? = nil , profileKeyName : String? = nil , urlString: String, completion: @escaping(([String: Any]?,  _ error: Error?)->())) {
        guard isReachable == true else {
            LoadingManager.shared.hideLoading()
            delay {
                LoadingManager.shared.showError(message: LocalizableConstants.Error.noNetworkConnection)
            }
            return
        }
        let url = URL(string: urlString)!
        debugPrint("API Url ->\(url.absoluteString)")
        debugPrint("API Payload -> \(parameter)")
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            for imageData in imagesData {
                // set key name as array if array contains more than 1 pics
                //                let keyName = imagesData.count > 1 ? "\(imageData.key)[]" : "\(imageData.key)"
                // append data
                MultipartFormData.append(imageData.value, withName: keyName ?? String(), fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            for imageData in profileImagesData {
                // set key name as array if array contains more than 1 pics
                //                let keyName = imagesData.count > 1 ? "\(imageData.key)[]" : "\(imageData.key)"
                // append data
                MultipartFormData.append(imageData.value, withName: profileKeyName ?? String(), fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in parameter {
                MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, to: url) { (encodingResult) in
            switch encodingResult {
            case .success(request: let request, streamingFromDisk: let streamingFromDisk, streamFileURL: let streamFileURL):
                request.responseJSON { response in
                    debugPrint("API Url ->\(url.absoluteString)")
                    
                    if let error = response.error {
                        debugPrint("API response ->\(error.localizedDescription)")
                        completion(nil, error)
                        
                    }
                    
                    if let data = response.data, let responseJSON = try? JSONSerialization
                        .jsonObject(with: data, options: []) as? [String : Any]{
                        debugPrint("API response ->\(String(describing: responseJSON))")
                        completion(responseJSON, nil)
                    }
                }
            case .failure(let encodingError):
                debugPrint("API response ->\(encodingError.localizedDescription)")
                completion(nil, encodingError)
            }
        }
    }
    
    
    func multipartImageRequestForSingleImage( parameter: Parameters, headers : [String : Any]? = nil, profileImagesData:[String: Data] = [String: Data]() , keyName : String? = nil , profileKeyName : String? = nil , urlString: String, completion: @escaping(([String: Any]?,  _ error: Error?)->())) {
        guard isReachable == true else {
            LoadingManager.shared.hideLoading()
            delay {
                LoadingManager.shared.showError(message: LocalizableConstants.Error.noNetworkConnection)
            }
            return
        }
        let url = URL(string: urlString)!
        debugPrint("API Url ->\(url.absoluteString)")
        debugPrint("API Payload -> \(parameter)")
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            
            for imageData in profileImagesData {
                // set key name as array if array contains more than 1 pics
                //                let keyName = imagesData.count > 1 ? "\(imageData.key)[]" : "\(imageData.key)"
                // append data
                MultipartFormData.append(imageData.value, withName: profileKeyName ?? String(), fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in parameter {
                MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, to: url) { (encodingResult) in
            switch encodingResult {
            case .success(request: let request, streamingFromDisk: let streamingFromDisk, streamFileURL: let streamFileURL):
                request.responseJSON { response in
                    debugPrint("API Url ->\(url.absoluteString)")
                    
                    if let error = response.error {
                        debugPrint("API response ->\(error.localizedDescription)")
                        completion(nil, error)
                        
                    }
                    
                    if let data = response.data, let responseJSON = try? JSONSerialization
                        .jsonObject(with: data, options: []) as? [String : Any]{
                        debugPrint("API response ->\(String(describing: responseJSON))")
                        completion(responseJSON, nil)
                    }
                }
            case .failure(let encodingError):
                debugPrint("API response ->\(encodingError.localizedDescription)")
                completion(nil, encodingError)
            }
        }
    }
    
    //------------------------------------------------------
}

struct Status {
    
    struct Code {
        
        static let emailNotVerified = 108
        static let success = 200
        static let unauthorized = 401
        static let notfound = 404
        static let sessionExpired = 500
    }
}
