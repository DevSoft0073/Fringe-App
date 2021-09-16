//
//  LogInVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 11/08/21.
//

import UIKit
import Foundation
import AppleSignIn
import AuthenticationServices
import IQKeyboardManagerSwift

class LogInVC : BaseVC, UITextFieldDelegate, UITextViewDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    
    @IBOutlet weak var eyeIcon: UIImageView!
    @IBOutlet weak var txtEmail: FGEmailTextField!
    @IBOutlet weak var txtPassword: FGPasswordTextField!
    
    var iconClick = true
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    
    func performLogin() {
        
        let deviceToken = PreferenceManager.shared.deviceToken ?? String()
        
        let parameter: [String: Any] = [
            Request.Parameter.email: txtEmail.text ?? String(),
            Request.Parameter.password: txtPassword.text ?? String(),
            Request.Parameter.deviceToken: deviceToken,
            Request.Parameter.deviceType: DeviceType.iOS.rawValue,
        ]
                
        RequestManager.shared.requestPOST(requestMethod: Request.Method.login, parameter: parameter, headers: [:], showLoader: false, decodingType: ResponseModal<UserModal>.self, successBlock: { (response: ResponseModal<UserModal>) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                
                if let stringUser = try? response.data?.jsonString() {
                    PreferenceManager.shared.currentUser = stringUser
                    PreferenceManager.shared.loggedUser = true
                    PreferenceManager.shared.authToken = response.data?.authorizationToken
                    PreferenceManager.shared.userId = response.data?.userID
                    NavigationManager.shared.setupLandingOnHome()
                }
                
            }else{
                
                delay {
                    
                    if response.code == Status.Code.emailNotVerified {
                        
                        DisplayAlertManager.shared.displayAlertWithNoYes(target: self, animated: true, message: LocalizableConstants.SuccessMessage.mailNotVerifiedYet, handlerNo: {
                            
                            NavigationManager.shared.setupLandingOnHome()
                            
                        }, handlerYes: {
                            
                            delay {
                                                                
                                delayInLoading {
                                    
//                                    self.performResentEmailVerification()
                                }
                            }
                        })
                        
                    }
                        else if response.code == Status.Code.notfound {
                        
                        DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.Error.invalidCredentials, handlerOK: nil)

                    }
                    else{
                        
                        delay {
                            
                            self.handleError(code: response.code)
                        }
                    }
                }
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            delay {
                DisplayAlertManager.shared.displayAlert(animated: true, message: error.errorDescription, handlerOK: nil)
            }
        })
    }

    func performAppleLogin(_ firstName: String, _ lastName: String, _ appleId: String, _ email: String) {
        
        let deviceToken = PreferenceManager.shared.deviceToken ?? String()
        
        let parameter: [String: Any] = [
            Request.Parameter.firstName: firstName,
            Request.Parameter.lastName: lastName,
            Request.Parameter.email:email,
            Request.Parameter.appleToken: appleId,
            Request.Parameter.deviceToken: deviceToken,
            Request.Parameter.deviceType: DeviceType.iOS.rawValue
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.aLogin, parameter: parameter, headers: [:] ,showLoader: false, decodingType: ResponseModal<UserModal>.self, successBlock: { (response: ResponseModal<UserModal>) in
            
            if response.code == Status.Code.success {
                
                LoadingManager.shared.hideLoading()
                
                if let stringUser = try? response.data?.jsonString() {
                    
                    PreferenceManager.shared.currentUser = stringUser
                    PreferenceManager.shared.authToken = response.data?.authorizationToken
                    PreferenceManager.shared.userId = response.data?.userID
                    PreferenceManager.shared.loggedUser = true
                    NavigationManager.shared.setupLandingOnHome()
                    
                }
                                
            } else {
                
                LoadingManager.shared.hideLoading()
                
                delay {
                    
                    self.handleError(code: response.code)
                    
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
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    //MARK: Customs
    
    func setup() {
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        //        btnRememberMe.delegate = self
        
        
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtEmail.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterEmail) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtEmail.text!, for: RegularExpressions.email) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidEmail) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtPassword.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterPassword) {
            }
            return false
        }
        
        return true
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnForgot(_ sender: Any) {
        let controller = NavigationManager.shared.forgotPasswordVC
        push(controller: controller)
        
    }
    
    @IBAction func btnLogInTapped(_ sender: Any) {
        
        if validate() == false {
            return
        }
        
        LoadingManager.shared.showLoading()

        performLogin()
                        
    }
    
    @IBAction func btnEye(_ sender: UIButton) {
        if(iconClick == true) {
            txtPassword.isSecureTextEntry = false
            eyeIcon.image = UIImage(named: FGImageName.iconOpenEye)
        } else {
            txtPassword.isSecureTextEntry = true
            eyeIcon.image = UIImage(named: FGImageName.iconEye)
        }
        iconClick = !iconClick
    }
    
    
    @IBAction func btnAppleTap(_ sender: Any) {
        /*guard let window = view.window else { return }
         
         let appleLoginManager = AppleLoginManager()
         appleLoginManager.delegate = self
         appleLoginManager.performAppleLoginRequest(in: window)*/
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @IBAction func btnGoogleTap(_ sender: Any) {
        
    }
    
    @IBAction func btnFaceBookTap(_ sender: Any) {
    }
    
    @IBAction func btnSignUpTap(_ sender: Any) {
        let controller = NavigationManager.shared.signUpVC
        push(controller: controller)
    }
    
    //------------------------------------------------------
    
    //MARK: AppleLoginDelegate
    
    func didCompleteAuthorizationWith(user: AppleUser) {
        
        print(user)
        
        LoadingManager.shared.showLoading()
        
        delayInLoading {
            /** var id: String
             var token: [String: Any]?
             var firstName: String
             var lastName: String
             var fullName: String {
             return firstName + " " + lastName
             }
             var email: String*/
            self.performAppleLogin(user.firstName, user.lastName, user.id, user.email)
        }
    }
    
    func didCompleteAuthorizationWith(error: Error) {
        
        DisplayAlertManager.shared.displayAlert(animated: true, message: error.localizedDescription)
    }
    
    //------------------------------------------------------
    
    //MARK: ASAuthorizationControllerDelegate
    
    // ASAuthorizationControllerDelegate function for successful authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName ?? String()
            let userLastName = appleIDCredential.fullName?.familyName ?? String()
            let userEmail = appleIDCredential.email ?? String()
            
            DispatchQueue.main.async {
                
                LoadingManager.shared.showLoading()
                
                delayInLoading {
                    self.performAppleLogin(userFirstName, userLastName, userIdentifier, userEmail)
                }
            }
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            print(username)
            print(password)
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.text = "dharmaniz.guleria@gmail.com"
        txtPassword.text = "Qwerty@123"
        setup()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
