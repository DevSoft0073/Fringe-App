//
//  SignUpVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 11/08/21.
//
import UIKit
import Toucan
import Foundation
import IQKeyboardManagerSwift
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn
import AppleSignIn
import AuthenticationServices

class SignUpVC : BaseVC, UITextFieldDelegate, UITextViewDelegate, ImagePickerDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @IBOutlet weak var txtLastName: FGUsernameTextField!
    @IBOutlet weak var txtEmail: FGEmailTextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var checkUncheckBtn: UIButton!
    @IBOutlet weak var txtUserName: FGUsernameTextField!
    @IBOutlet weak var txtBirthDate: FGBirthDateTextField!
    @IBOutlet weak var txtGender: FGGenderTextField!
    @IBOutlet weak var txtMobileNumber: FGMobileNumberTextField!
    @IBOutlet weak var txtHomeTown: FGUsernameTextField!
    @IBOutlet weak var txtProffession: FGUsernameTextField!
    @IBOutlet weak var txtMemberCourse: FGUsernameTextField!
    @IBOutlet weak var txtGolfHandicap: FGGolfHandiCap!
    @IBOutlet weak var txtPassword: FGPasswordTextField!
    @IBOutlet weak var txtConfirmPassword: FGPasswordTextField!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var unchecked = Bool()
    var imagePickerVC: ImagePicker?
    var selectedImage: UIImage? {
        didSet {
            if selectedImage != nil {
                imgProfile.image = selectedImage
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {
        imgProfile.image = getPlaceholderImage()
        imagePickerVC = ImagePicker(presentationController: self, delegate: self)
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtUserName.delegate = self
        txtHomeTown.delegate = self
        txtBirthDate.delegate = self
        txtGender.delegate = self
        txtProffession.delegate = self
        txtMobileNumber.delegate = self
        txtMemberCourse.delegate = self
        txtGolfHandicap.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtUserName.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterFirstName) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtLastName.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterLastName) {
            }
            return false
        }
        
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
        
        
        if ValidationManager.shared.isEmpty(text: txtBirthDate.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.selectBirthDate) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtGender.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.selectGender) {
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtMobileNumber.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidMobileNumber) {
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtHomeTown.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterHomeTown) {
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtProffession.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterProffession) {
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtMemberCourse.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterMemberCousre) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtPassword.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterPassword) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtPassword.text!, for: RegularExpressions.password8AS) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidPassword) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtConfirmPassword.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterRetypePassword) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtPassword.text!, for: RegularExpressions.password8AS) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidRetypePassword) {
            }
            return false
        }
        
        if ValidationManager.shared.isValidConfirm(password: txtPassword.text!, confirmPassword: txtConfirmPassword.text!) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.NewRetypePasswordNotMatch) {
            }
            return false
        }
        
        if unchecked == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.agreeTermsAndConditions) {
            }
            return false
        }
        
        return true
    }
    
    //------------------------------------------------------
    
    //MARK: Sign Up
    
    private func performSignUp() {
       
        let imageData = selectedImage?.jpegData(compressionQuality: 0.2)
        var imgData = [String : Data]()
        imgData["image"] = imageData
        let deviceTimeZone = TimeZone.current.abbreviation()
        let parameter: [String: Any] = [
            Request.Parameter.fullName: txtUserName?.text ?? String(),
            
            Request.Parameter.email: txtEmail.text ?? String(),
            Request.Parameter.dob: txtBirthDate?.text ?? String(),
            Request.Parameter.gender: txtGender?.text ?? String(),
            Request.Parameter.mobileNumber: txtMobileNumber?.text ?? String(),
            Request.Parameter.homeTown: txtHomeTown?.text ?? String(),
            Request.Parameter.profession: txtProffession?.text ?? String(),
            Request.Parameter.memberCourse: txtMemberCourse?.text ?? String(),
            Request.Parameter.golfHandicap: txtGolfHandicap?.text ?? String(),
            Request.Parameter.password: txtPassword?.text ?? String(),
            Request.Parameter.confirmPassword: txtConfirmPassword?.text ?? String(),
            Request.Parameter.timeZone: deviceTimeZone ?? String(),
            
        ]
        
        RequestManager.shared.multipartImageRequestForSingleImage(parameter: parameter, profileImagesData: imgData, keyName: "image[]", profileKeyName: "image", urlString: PreferenceManager.shared.userBaseURL + Request.Method.signup) { (response, error) in
            
            if error == nil{
                
                if let data = response {
                    
                    LoadingManager.shared.hideLoading()
                    
                    let status = data["code"] as? Int ?? 0
                    let jsonStudio = data["studio_detail"] as? [String: Any]
                    if status == Status.Code.success {
                        PreferenceManager.shared.currentUser = jsonStudio?.dict2json()
                        delay {
                            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.SuccessMessage.verificationMailSent.localized()) {
                                self.pop()
                            }
                        }
                        
                    }else{
                        
                        delay {
                            
                            DisplayAlertManager.shared.displayAlert(animated: true, message: data["message"] as? String ?? "", handlerOK: nil)
                            
                        }
                    }
                }
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Apple Login Service Call
    
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
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.aLogin, parameter: parameter, showLoader: false, decodingType: ResponseModal<UserModal>.self, successBlock: { (response: ResponseModal<UserModal>) in
            
            if response.code == Status.Code.success {
                
                LoadingManager.shared.hideLoading()
                
                if let stringUser = try? response.data?.jsonString() {
                    
                    PreferenceManager.shared.currentUser = stringUser
                    PreferenceManager.shared.userId = response.data?.userID
                    NavigationManager.shared.setupLandingOnHome()
                    
                }
                
                NavigationManager.shared.setupLanding()
                
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
    
    //MARK: Actions
    
    @IBAction func btnProfileImg(_ sender: UIButton) {
        self.imagePickerVC?.present(from: sender)
    }
    
    
    @IBAction func btnCheckUncheck(_ sender: Any) {
        if (unchecked == false)
        {
            checkUncheckBtn.setBackgroundImage(UIImage(named: FGImageName.iconCheck), for: UIControl.State.normal)
            unchecked = true
        }
        else
        {
            checkUncheckBtn.setBackgroundImage(UIImage(named: FGImageName.iconUncheck), for: UIControl.State.normal)
            unchecked = false
        }
    }
    
    @IBAction func btnTermCondition(_ sender: Any) {
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        
        if validate() == false {
            return
        }
        
        LoadingManager.shared.showLoading()
        
        self.performSignUp()
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
    
    @IBAction func btnFacebookTap(_ sender: Any) {
    }
    
    
    @IBAction func btnLoginTap(_ sender: Any) {
        self.pop()
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
    
    //MARK: FGImagePickerDelegate
    
    func didSelect(image: UIImage?) {
        if let imageData = image?.jpegData(compressionQuality: 0), let compressImage = UIImage(data: imageData) {
            self.selectedImage = Toucan.init(image: compressImage).resizeByCropping(FGSettings.profileImageSize).maskWithRoundedRect(cornerRadius: FGSettings.profileImageSize.width/2, borderWidth: FGSettings.profileBorderWidth, borderColor: FGColor.appGreen).image
            imgProfile.image = selectedImage
        }
    }
    
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

