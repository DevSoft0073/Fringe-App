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
import Alamofire
import SKCountryPicker
import IQKeyboardManagerSwift

class EditProfileVC : BaseVC , UITextFieldDelegate, UITextViewDelegate,ImagePickerDelegate {
    
    
    @IBOutlet weak var countryCode: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFirstName: FGUsernameTextField!
    @IBOutlet weak var txtLastName: FGUsernameTextField!
    @IBOutlet weak var txtBirthDate: FGBirthDateTextField!
    @IBOutlet weak var txtEmail: FGEmailTextField!
    @IBOutlet weak var txtGender: FGGenderTextField!
    @IBOutlet weak var txtMobileNumber: FGMobileNumberTextField!
    
    var countryCodes = String()
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
        txtEmail.isUserInteractionEnabled = false
        
        self.countryCode.contentHorizontalAlignment = .center
        guard let country = CountryManager.shared.currentCountry else {
            return
        }
        countryCode.setTitle(country.countryCode, for: .highlighted)
        countryCode.clipsToBounds = true
        
    }
    
    func setupData() {
        
        //image
        imgProfile.sd_addActivityIndicator()
        imgProfile.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        imgProfile.sd_showActivityIndicatorView()
        if let image = currentUser?.image, image.isEmpty == false {
            let imgURL = URL(string: image)
            imgProfile.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                if let serverImage = serverImage {
                    self.selectedImage = serverImage
                    self.imgProfile.image = Toucan.init(image: serverImage).resizeByCropping(FGSettings.profileImageSize).maskWithRoundedRect(cornerRadius: FGSettings.profileImageSize.width/2, borderWidth: FGSettings.profileBorderWidth, borderColor: FGColor.appGreen).image
                }
                self.imgProfile.sd_removeActivityIndicator()
            }
        } else {
            self.imgProfile.sd_removeActivityIndicator()
        }
        
        //firstname
        txtFirstName.text = currentUser?.firstName
        
        //firstname
       // txtFirstName.text = currentUser?.name
        
        //lastName
        txtLastName.text = currentUser?.lastName
        
        //dob
        txtBirthDate.text = currentUser?.dob
        
        //gender
        txtGender.text = currentUser?.gender
        
        //email
        txtEmail.text = currentUser?.email
        
        //phone
        txtMobileNumber.text = currentUser?.mobileNo
        
        //country code
        if currentUser?.countryCode == "" {
            countryCode.setTitle("+1", for: .normal)
        } else {
            countryCode.setTitle(currentUser?.countryCode, for: .normal)
        }
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
        
        return true
    }
    
    private func performEditProfile(completion:((_ flag: Bool) -> Void)?) {
                    
        let imageData = selectedImage?.jpegData(compressionQuality: 0.2)
        var imgData = [String : Data]()
        imgData["image"] = imageData
        let deviceTimeZone = TimeZone.current.abbreviation()
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
           ]
        let parameter: [String: Any] = [
            Request.Parameter.userID: currentUser?.userID ?? String(),
            Request.Parameter.firstName: txtFirstName?.text ?? String(),
            Request.Parameter.lastName: txtLastName.text ?? String(),
            Request.Parameter.dob: txtBirthDate?.text ?? String(),
            Request.Parameter.gender: txtGender?.text ?? String(),
            Request.Parameter.homeTown: txtEmail?.text ?? String(),
            Request.Parameter.mobileNumber: txtMobileNumber?.text ?? String(),
            Request.Parameter.timeZone: deviceTimeZone ?? String(),
            Request.Parameter.countryCode: countryCodes,
            
        ]
        
        RequestManager.shared.multipartImageRequestForSingleImage(parameter: parameter, headers: headers, profileImagesData: imgData, keyName: "image", profileKeyName: "image", urlString: PreferenceManager.shared.userBaseURL + Request.Method.edit) { (response, error) in
            
            if error == nil{
                
                if let data = response {
                    
                    LoadingManager.shared.hideLoading()
                    
                    let status = data["code"] as? Int ?? 0
                    let jsonStudio = data["data"] as? [String: Any]
                    if status == Status.Code.success {
                        PreferenceManager.shared.currentUser = jsonStudio?.dict2json()
                        delay {
                            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.SuccessMessage.profileUpdated.localized()) {
                                self.pop()
                            }

                        }
                        
                    }else{
                        
                        delay {
                            
                            DisplayAlertManager.shared.displayAlert(target: self, animated: false, message: LocalizableConstants.Error.anotherLogin) {
                                PreferenceManager.shared.userId = nil
                                PreferenceManager.shared.currentUser = nil
                                PreferenceManager.shared.authToken = nil
                                NavigationManager.shared.setupSingIn()
                            }
                        }

                    }
                }
            }
        }
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
        
        LoadingManager.shared.showLoading()
        
        self.performEditProfile { (flag) in
        }
    }
    
    @IBAction func btnCountryPicker(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            self.countryCode.setTitle(country.dialingCode, for: .normal)
            self.countryCodes = country.dialingCode ?? String()
        }
        
        countryController.detailColor = UIColor.red
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
        setupData()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenu = false
        txtGender.tintColor = .clear
        txtBirthDate.tintColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgProfile.circle()
    }
    
    //------------------------------------------------------
}
