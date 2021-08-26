//
//  EditProfileVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 18/08/21.
//
import UIKit
import Toucan
import SDWebImage
import Foundation
import IQKeyboardManagerSwift


class EditProfileVC : BaseVC , UITextFieldDelegate, UITextViewDelegate,ImagePickerDelegate {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFirstName: FGUsernameTextField!
    @IBOutlet weak var txtLastName: FGUsernameTextField!
    @IBOutlet weak var txtBirthDate: FGBirthDateTextField!
    @IBOutlet weak var txtEmail: FGEmailTextField!
    @IBOutlet weak var txtGender: FGGenderTextField!
    @IBOutlet weak var txtMobileNumber: FGMobileNumberTextField!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
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
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtBirthDate.delegate = self
        txtGender.delegate = self
        txtEmail.delegate = self
        txtMobileNumber.delegate = self
        
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtFirstName.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterFirstName) {
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtLastName.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterLastName) {
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
        if ValidationManager.shared.isEmpty(text: txtEmail.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterEmail) {
            }
            return false
        }
        
        return true
    }
    
    private func performEditProfile(completion:((_ flag: Bool) -> Void)?) {
                    
        let imageData = selectedImage?.jpegData(compressionQuality: 0.2)
        var imgData = [String : Data]()
        imgData["image"] = imageData
        let deviceTimeZone = TimeZone.current.abbreviation()
        let parameter: [String: Any] = [
            Request.Parameter.fullName: txtEmail?.text ?? String(),
//            Request.Parameter.email: txtEmail.text ?? String(),
//            Request.Parameter.dob: txtBirthDate?.text ?? String(),
//            Request.Parameter.gender: txtGender?.text ?? String(),
//            Request.Parameter.mobileNumber: txtMobileNumber?.text ?? String(),
//            Request.Parameter.homeTown: txtHomeTown?.text ?? String(),
//            Request.Parameter.profession: txtProffession?.text ?? String(),
//            Request.Parameter.memberCourse: txtMemberCourse?.text ?? String(),
//            Request.Parameter.golfHandicap: txtGolfHandicap?.text ?? String(),
//            Request.Parameter.password: txtPassword?.text ?? String(),
//            Request.Parameter.confirmPassword: txtConfirmPassword?.text ?? String(),
//            Request.Parameter.timeZone: deviceTimeZone ?? String(),
            
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.signup, parameter: parameter, showLoader: false, decodingType: BaseResponseModal.self, successBlock: { (response: BaseResponseModal) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                
                delay {
                    completion?(true)
                }
                
            } else {
                
                completion?(false)
                                
                delay {
//                   self.handleError(code: response.code)
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
    
    @IBAction func btnProfileImg(_ sender: Any) {
        self.imagePickerVC?.present(from: (sender as? UIView)!)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if validate() == false {
            return
        }
        self.pop()
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
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if IQKeyboardManager.shared.canGoNext {
            IQKeyboardManager.shared.goNext()
        } else {
            self.view.endEditing(true)
        }
        return true
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
        NavigationManager.shared.isEnabledBottomMenu = false
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgProfile.circle()
    }
    
    //------------------------------------------------------
}
