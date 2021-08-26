//
//  EditProfileVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 18/08/21.
//
import UIKit
import Foundation
import IQKeyboardManagerSwift
import SDWebImage
import Toucan

class EditProfileVC : BaseVC , UITextFieldDelegate , UITextViewDelegate {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFirstName: FGUsernameTextField!
    @IBOutlet weak var txtLastName: FGUsernameTextField!
    @IBOutlet weak var txtBirthDate: FGBirthDateTextField!
    @IBOutlet weak var txtEmail: FGEmailTextField!
    @IBOutlet weak var txtGender: FGGenderTextField!
    @IBOutlet weak var txtMobileNumber: FGMobileNumberTextField!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var imagePickerVC: ImagePicker?
    
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
        //                imgProfile.image = getPlaceholderImage()
        //                imagePickerVC = ImagePicker(presentationController: self, delegate: self)
        
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
    
    //    func didSelect(controller: ImagePicker, image: UIImage?) {
    //        <#code#>
    //    }
    
    
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
