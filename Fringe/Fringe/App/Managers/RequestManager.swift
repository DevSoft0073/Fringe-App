
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
        static let golfID = "golf_id"
        
        // chnage password
        static let newPassword = "new_password"
        static let oldPassword = "old_password"
        static let lastID = "last_id"
        
        //home
        static let search = "search"
        static let lats = "Latitude"
        static let longs = "Longitude"
        
        //sign up as host
        static let golfName = "golf_course_name"
        static let location = "location"
        static let price = "price"
        static let description = "description"
        
        //feedback
        static let rating = "rating"
        static let review = "review"
        
        //Booking listing
        static let bookedStatus = "booked_status"
        
        //Add request
        static let dates = "dates"
        
        //Add account
        static let imgType = "image_type"
        
        //Add card
        static let stripeToken = "stripeToken"
        
        //add studio
        
        static let country = "country"
        static let address = "address"
        static let city = "city"
        static let state = "state"
        static let postal_code = "postal_code"
        static let line1 = "line1"
        static let line2 = "line2"
        static let ssnLast4 = "ssn_last_4"
        static let accountHolderName = "account_holder_name"
        static let routingNumber = "routing_number"
        static let accountNumber = "account_number"
        static let idNumber = "id_number"
        static let back = "back"
        static let front = "front"
        
        //Payment
        static let token = "stripe_token"
        static let totalAmount = "total_amount"
        static let totalGuest = "totalGuest"
        
        //Add slot
        
        static let isBlock = "isblock"
        static let type = "type"
       
    }
    
    struct Method {
        
        static let signup = "/SignUp.php"
        static let login = "/Login.php"
        static let aLogin = "/appleLogin.php"
        static let edit = "/editProfile.php"
        static let changePassword = "/ChangePassword.php"
        static let profile = "/GetProfileDetails.php"
        static let forgotPassword = "/Forgotpassword.php"
        static let favoriteListing = "/favouriteListing.php"
        static let favUnfav = "/GolfFavouriteUnfavourite.php"
        static let home = "/Home.php"
        static let myBooking = "/GetAllHistoryBooking.php"
        static let signUpAsHost = "/signUp_asHost.php"
        static let addRating = "/AddGolfrating.php"
        static let bookingListForPlayer = "/GetHostBookingDetails.php"
        static let checkRequest = "/CheckAvaliablity.php"
        static let bookingRequest = "/BookingRequest.php"
        static let cancleRequest = "/Bookingcancel.php"
        static let notification = "/GetNotificationDetails.php"
        static let uploadDocument = "/UploadstripeDocument.php"
        static let addAccountDetails = "/ConnectedStripeToHost.php"
        static let hostProfile = "/getHostDetails.php"
        static let updateLocation = "/UpdateUserLocation.php"
        static let editHostProfile = "/EditHostProfile.php"
        static let cardListing = "/GetAllCardDetailsBYuserid.php"
        static let addcard = "/SaveUserCardDetails.php"
        static let payNow = "/PayForGolf.php"
        static let abbBlockDate = "/AddBlockAvalibleDate.php"
        static let acceptReject = "/AcceptRejectBooking.php"
        static let playersBooking = "/GetAllBookingListingByUserid.php"
        static let logout = "/LogOut.php"
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
    
    fileprivate func requestREST<T: Decodable>(type: HTTPMethod, requestMethod : String, parameter : [String : Any], header : HTTPHeaders,showLoader : Bool, decodingType: T.Type, successBlock:@escaping (( _ response: T)->Void), failureBlock:@escaping (( _ error : ErrorModal) -> Void)) {
        
        guard isReachable == true else {
            LoadingManager.shared.hideLoading()
            delay {
                LoadingManager.shared.showError(message: LocalizableConstants.Error.noNetworkConnection)
            }
            return
        }
        
        var requestURL: String = String()
        // var headers: HTTPHeaders = [:]
        // headers["content-type"] = "application/json"
        /*if type == .post {
         headers["content-type"] = "application/x-www-form-urlencoded"
         }*/
        requestURL = PreferenceManager.shared.userBaseURL.appending(requestMethod)
        
        debugPrint("----------- \(requestMethod) ---------")
        debugPrint("requestURL:\(requestURL)")
        // debugPrint("requestHeader:\(headers)")
        print("parameter:\(parameter.dict2json())")
        
        if showLoader == true {
            LoadingManager.shared.showLoading()
        }
        
        backgroundFetch(requestMethod)
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 60
        
        let encodingType: ParameterEncoding = (type == HTTPMethod.post) ? JSONEncoding.default : URLEncoding.default
        request(requestURL, method: type, parameters: parameter, encoding: encodingType, headers: header).responseData { (response: DataResponse<Data>) in
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
    
    func requestGET<T: Decodable>(requestMethod : String, parameter : [String : Any], header : HTTPHeaders, showLoader : Bool, decodingType: T.Type, successBlock:@escaping (( _ response: T)->Void), failureBlock:@escaping (( _ error : ErrorModal) -> Void)) {
        
        requestREST(type: HTTPMethod.get, requestMethod: requestMethod, parameter: parameter, header: header, showLoader: showLoader, decodingType: decodingType, successBlock: { (response: T) in
            
            successBlock(response)
            
        }, failureBlock: { (error: ErrorModal) in
            
            failureBlock(error)
        })
    }
    
    //------------------------------------------------------
    
    //MARK: POST
    
    func requestPOST<T: Decodable>(requestMethod : String, parameter : [String : Any], headers : HTTPHeaders , showLoader : Bool, decodingType: T.Type, successBlock:@escaping (( _ response: T)->Void), failureBlock:@escaping (( _ error : ErrorModal) -> Void)) {
        
        requestREST(type: HTTPMethod.post, requestMethod: requestMethod, parameter: parameter, header: headers , showLoader: showLoader, decodingType: decodingType, successBlock: { (response: T) in
            
            successBlock(response)
            
        }, failureBlock: { (error: ErrorModal) in
            
            failureBlock(error)
        })
    }
    
    //------------------------------------------------------
    
    //MARK: Form Data
    
    func multipartImageRequest( parameter: Parameters, imagesData:[String: Data] = [String: Data](), headers : HTTPHeaders , profileImagesData:[String: Data] = [String: Data]() , keyName : String? = nil , profileKeyName : String? = nil , urlString: String, completion: @escaping(([String: Any]?, _ error: Error?)->())) {
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
                // let keyName = imagesData.count > 1 ? "\(imageData.key)[]" : "\(imageData.key)"
                // append data
                MultipartFormData.append(imageData.value, withName: keyName ?? String(), fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            for imageData in profileImagesData {
                // set key name as array if array contains more than 1 pics
                // let keyName = imagesData.count > 1 ? "\(imageData.key)[]" : "\(imageData.key)"
                // append data
                MultipartFormData.append(imageData.value, withName: profileKeyName ?? String(), fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in parameter {
                MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, to: url , headers: headers) { (encodingResult) in
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
    
    func multipartImageRequestForSingleImage( parameter: Parameters, headers : HTTPHeaders , profileImagesData:[String: Data] = [String: Data]() , keyName : String? = nil , profileKeyName : String? = nil , urlString: String, completion: @escaping(([String: Any]?, _ error: Error?)->())) {
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
        // debugPrint("requestHeader:\(headers)")
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            
            for imageData in profileImagesData {
                // set key name as array if array contains more than 1 pics
                // let keyName = imagesData.count > 1 ? "\(imageData.key)[]" : "\(imageData.key)"
                // append data
                MultipartFormData.append(imageData.value, withName: profileKeyName ?? String(), fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in parameter {
                MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, to: url, headers: headers) { (encodingResult) in
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
        static let notRegistered = 107
        static let alreadyAdded = 420
        static let stripeIssue = 507
        static let alreadyAddedCard = 518
        static let nofoundDat = 503
    }
}
