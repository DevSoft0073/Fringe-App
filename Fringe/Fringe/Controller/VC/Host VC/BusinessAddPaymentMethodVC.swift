//
//  BusinessAddPaymentMethodVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 06/09/21.
//

import UIKit
import Foundation
import Toucan
import IQKeyboardManagerSwift

class BusinessAddPaymentMethodVC : BaseVC, UITextFieldDelegate, UploadImages, ImagePickerDelegate {
   
    @IBOutlet weak var addBackImageTxtField: FGAddBackImagesTextField!
    @IBOutlet weak var addImageTxtField: FGAddImagesTextField!
    @IBOutlet weak var ssnNumberTxt: FGSSNTextField!
    @IBOutlet weak var routingNumberTxt: FGRoutingNumberTextField!
    @IBOutlet weak var accountNumberTxt: FGAccountNumberTextField!
    @IBOutlet weak var accountHoldrNameTxt: FGAccountHolderNameTextField!
    
    var tagValue = Int()
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var imagePickerVC: ImagePicker?
    var selectedImg = UIImage()
    var selectedImage: UIImage? {
        didSet {
            if selectedImage != nil {
                selectedImage = selectedImg
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
    
    //MARK: Custome
    
    //------------------------------------------------------
    
    func setup() {
        
        imagePickerVC = ImagePicker(presentationController: self, delegate: self)
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        
        addBackImageTxtField.delegate = self
        addImageTxtField.delegate = self
        ssnNumberTxt.delegate = self
        routingNumberTxt.delegate = self
        accountNumberTxt.delegate = self
        accountHoldrNameTxt.delegate = self
        
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: accountHoldrNameTxt.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterAccountHolderName) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: accountNumberTxt.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterAccountNumber) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: accountNumberTxt.text!, for: RegularExpressions.accountNumber) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidAccountNumber) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: routingNumberTxt.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterRoutingNumber) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: routingNumberTxt.text!, for: RegularExpressions.routingNumber) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidRoutingNumber) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: ssnNumberTxt.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterSSN) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: ssnNumberTxt.text!, for: RegularExpressions.ssnNumber) == false {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterValidRoutingNumber) {
            }
            return false
        }
      
        if ValidationManager.shared.isEmpty(text: addImageTxtField.text!) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterFrontImage) {
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: addBackImageTxtField.text!) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterBackImage) {
            }
            return false
        }
        
        return true
    }
    
    private func performFrontImgDocument(selectedImg : UIImage) {

        let parameter: [String: Any] = [
            Request.Parameter.userID: PreferenceManager.shared.userId ?? String(),
            Request.Parameter.imgType: "front",
            Request.Parameter.golfID: currentUserHost?.golfID ?? String(),
        ]

        let imgData = selectedImg.jpegData(compressionQuality: 0.4)
        var imgDataa = [String : Data]()
        imgDataa["image"] = imgData
        RequestManager.shared.multipartImageRequest(parameter: parameter, imagesData: imgDataa,keyName: "image", urlString: PreferenceManager.shared.userBaseURL + Request.Method.uploadDocument) { (response, error) in
            if error == nil{
                if let data = response {

                    LoadingManager.shared.hideLoading()

                    let status = data["code"] as? Int ?? 0
                    if status == Status.Code.success {
                        LoadingManager.shared.hideLoading()
                        self.frontImageID = data["file_id"] as? String ?? ""
                        self.addFrontImageTxtFld.text = data["file_id"] as? String ?? ""
                    }else{
                        DisplayAlertManager.shared.displayAlert(animated: true, message: data["message"] as? String ?? "", handlerOK: nil)
                    }
                }
            }
            LoadingManager.shared.hideLoading()
            print(error?.localizedDescription ?? String())
        }
    }
   
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnSubmit(_ sender: Any) {
        if validate() == false {
            return
        }
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    //------------------------------------------------------
    
    //MARK: Text field delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == addImageTxtField{
            return false
        }
        if textField == addBackImageTxtField{
            return false
        }
        return true
    }
    
    func pickImage(tag: Int) {
        tagValue = tag
        if tag == 0{
            self.imagePickerVC?.present(from: view)
        }else if tag == 1{
            self.imagePickerVC?.present(from: view)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: FGImagePickerDelegate
        
    func didSelect(image: UIImage?) {
        if tagValue == 0{
//            LoadingManager.shared.showLoading()
//            delay {
//                self.performFrontImgDocument(selectedImg: image ?? UIImage())
//            }
        }else if tagValue == 1{
//            LoadingManager.shared.showLoading()
//            delay {
//                self.performBackImgDocument(selectedImg: image ?? UIImage())
//            }
        }
        if let imageData = image?.jpegData(compressionQuality: 0), let compressImage = UIImage(data: imageData) {
            self.selectedImage = Toucan.init(image: compressImage).image

        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == ssnNumberTxt{
            
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = { return strcmp(char, "\\b") == -92}
            
            if (ssnNumberTxt.text?.count == 3 && !isBackSpace()) || (ssnNumberTxt.text?.count == 6 && !isBackSpace()){
                textField.text = textField.text! + "-"
            }
            
            if (textField.text?.count) == 11 && !isBackSpace(){
                ssnNumberTxt.text = ssnNumberTxt.text!
                self.view.endEditing(true)
                
            }
            return true
        }
        return true
    }

    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addImageTxtField.uploadDelegate = self
        addBackImageTxtField.uploadDelegate = self
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenuForHost = false
        
    }
    
    //------------------------------------------------------
}
