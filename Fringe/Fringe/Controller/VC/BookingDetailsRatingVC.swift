//
//  BookingDetailsRatingVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 21/08/21.
//

import UIKit
import Foundation

class BookingDetailsRatingVC : BaseVC {
    
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var txtViewQuery: UITextView!
    
    var golfID = String()
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtViewQuery.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterPassword) {
            }
            return false
        }
        
        return true
    }
    
    private func performAddFeedback(completion:((_ flag: Bool) -> Void)?) {
        
        let parameter: [String: Any] = [
            Request.Parameter.userID: currentUser?.userID ?? String(),
            Request.Parameter.golfID: "",
            Request.Parameter.rating: "",
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
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}

