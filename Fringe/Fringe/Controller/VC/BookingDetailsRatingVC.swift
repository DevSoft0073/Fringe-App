//
//  BookingDetailsRatingVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 21/08/21.
//

import UIKit
import Alamofire
import Foundation

class BookingDetailsRatingVC : BaseVC {
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var txtViewQuery: UITextView!
    
    var feedBackDat: FeedbackDetailModal?
    var bookingDetails: BookingModal?
    var golfID = String()
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setupUI()  {
        
        // set text view data
        self.txtViewQuery.text = feedBackDat?.review ?? String()
        
        // set rating value
        self.ratingView.rating = Double(feedBackDat?.rating ?? String()) ?? 0.0
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtViewQuery.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterQuery) {
            }
            return false
        }
        
        return true
    }
    
    private func performAddFeedback(completion:((_ flag: Bool) -> Void)?) {
        
        let parameter: [String: Any] = [
            Request.Parameter.userID: currentUser?.userID ?? String(),
            Request.Parameter.golfID: golfID,
            Request.Parameter.rating: ratingView.rating,
            Request.Parameter.review: txtViewQuery.text ?? String(),
            
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.addRating, parameter: parameter, headers: [:], showLoader: false, decodingType: BaseResponseModal.self, successBlock: { (response: BaseResponseModal) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                
                DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: response.message ?? String()) {
                    
                    self.popBack(3)
                    
                }
                delay {
                    completion?(true)
                }
                
            } else {
                
                delay {
                    DisplayAlertManager.shared.displayAlert(animated: true, message: response.message ?? String(), handlerOK: nil)
                }
                
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            delay {
                
                DisplayAlertManager.shared.displayAlert(target: self, animated: false, message: LocalizableConstants.Error.anotherLogin) {
                    PreferenceManager.shared.userId = nil
                    PreferenceManager.shared.currentUser = nil
                    PreferenceManager.shared.authToken = nil
                    NavigationManager.shared.setupSingIn()
                }
            }
        })
    }
    
    private func performGetFeedbackDetails(completion:((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        let parameter: [String: Any] = [
            Request.Parameter.golfID: bookingDetails?.golfID ?? String(),
            
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.getFeedbackDetails, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<FeedbackDetailModal>.self, successBlock: { (response: ResponseModal<FeedbackDetailModal>) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                
                if response.data?.isRating == "0" {
                    self.btnSubmit.isHidden = false
                } else {
                    self.btnSubmit.isHidden = true
                    self.ratingView.isUserInteractionEnabled = false
                    self.txtViewQuery.isUserInteractionEnabled = false
                }
                self.feedBackDat = response.data
                self.setupUI()
                //
                delay {
                    completion?(true)
                }
                
            } else {
                
                
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            delay {
                DisplayAlertManager.shared.displayAlert(animated: true, message: error.errorDescription, handlerOK: nil)
            }
        })
    }
    
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        
        if validate() == false {
            return
        }
        self.view.endEditing(true)
        
        LoadingManager.shared.showLoading()
        
        self.performAddFeedback { (flag: Bool) in
            
            if flag {
                DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.SuccessMessage.submitFeedback.localized()) {
                    self.ratingView.rating = 0
                    self.txtViewQuery.text = ""
                    self.popWithoutAnimate()
                }
            }
        }
        
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadingManager.shared.showLoading()
        
        self.performGetFeedbackDetails { (flag : Bool) in
            
        }
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}

