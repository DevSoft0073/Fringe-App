//
//  BusinessAddPaymentMethodVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 06/09/21.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import Foundation
import Toucan
import IQKeyboardManagerSwift

class BusinessAddPaymentMethodVC : BaseVC, UITextFieldDelegate, UploadImages, ImagePickerDelegate, LocationSearchDelegate {
    
    @IBOutlet weak var txtAddress: FGGolfAddressTextField!
    @IBOutlet weak var addBackImageTxtField: FGAddBackImagesTextField!
    @IBOutlet weak var addImageTxtField: FGAddImagesTextField!
    @IBOutlet weak var ssnNumberTxt: FGSSNTextField!
    @IBOutlet weak var routingNumberTxt: FGRoutingNumberTextField!
    @IBOutlet weak var accountNumberTxt: FGAccountNumberTextField!
    @IBOutlet weak var accountHoldrNameTxt: FGAccountHolderNameTextField!
    
    var lat = String()
    var long = String()
    var countyCode = String()
    var stateName = String()
    var cityName = String()
    var postlaCode = String()
    var line1 = String()
    var line2 = String()
    var selectedTimeZone = String()
    var selectedCountry = String()
    var textTitle: String?
    var locations = [Location]()
    var address = String()
    var frontImageID = String()
    var backImageID = String()
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

        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        let parameter: [String: Any] = [
            Request.Parameter.userID: PreferenceManager.shared.userId ?? String(),
            Request.Parameter.imgType: "front",
            Request.Parameter.golfID: currentUserHost?.golfID ?? String(),
        ]

        let imgData = selectedImg.jpegData(compressionQuality: 0.4)
        var imgDataa = [String : Data]()
        imgDataa["image"] = imgData
        RequestManager.shared.multipartImageRequest(parameter: parameter, imagesData: imgDataa, headers: headers ,keyName: "image", urlString: PreferenceManager.shared.userBaseURL + Request.Method.uploadDocument) { (response, error) in
            if error == nil{
                if let data = response {

                    LoadingManager.shared.hideLoading()

                    let status = data["code"] as? Int ?? 0
                    if status == Status.Code.success {
                        LoadingManager.shared.hideLoading()
                        self.frontImageID = data["data"] as? String ?? ""
                        self.addImageTxtField.text = data["data"] as? String ?? ""
                    }else{
                        DisplayAlertManager.shared.displayAlert(animated: true, message: data["message"] as? String ?? "", handlerOK: nil)
                    }
                }
            }
            LoadingManager.shared.hideLoading()
            print(error?.localizedDescription ?? String())
        }
    }
    
    private func performBackImgDocument(selectedImg : UIImage) {

        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        let parameter: [String: Any] = [
            Request.Parameter.userID: PreferenceManager.shared.userId ?? String(),
            Request.Parameter.imgType: "back",
            Request.Parameter.golfID: currentUserHost?.golfID ?? String(),
        ]

        let imgData = selectedImg.jpegData(compressionQuality: 0.4)
        var imgDataa = [String : Data]()
        imgDataa["image"] = imgData
        RequestManager.shared.multipartImageRequest(parameter: parameter, imagesData: imgDataa, headers: headers ,keyName: "image", urlString: PreferenceManager.shared.userBaseURL + Request.Method.uploadDocument) { (response, error) in
            if error == nil{
                if let data = response {

                    LoadingManager.shared.hideLoading()

                    let status = data["code"] as? Int ?? 0
                    if status == Status.Code.success {
                        LoadingManager.shared.hideLoading()
                        self.backImageID = data["data"] as? String ?? ""
                        self.addBackImageTxtField.text = data["data"] as? String ?? ""
                    }else{
                        DisplayAlertManager.shared.displayAlert(animated: true, message: data["message"] as? String ?? "", handlerOK: nil)
                    }
                }
            }
            LoadingManager.shared.hideLoading()
            print(error?.localizedDescription ?? String())
        }
    }

    private func performAddGolfClub(completion:((_ flag: Bool) -> Void)?) {
        let deviceTimeZone = TimeZone.current.abbreviation()
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        let parameter: [String: Any] = [
            Request.Parameter.userID: PreferenceManager.shared.userId ?? String(),
            Request.Parameter.accountHolderName: accountHoldrNameTxt.text ?? String(),
            Request.Parameter.accountNumber: accountNumberTxt.text ?? String(),
            Request.Parameter.routingNumber: routingNumberTxt.text ?? String(),
            Request.Parameter.idNumber: ssnNumberTxt.text?.replacingOccurrences(of: "-", with: "") ?? String(),
            Request.Parameter.ssnLast4: ssnNumberTxt.text?.suffix(4) ?? String(),
            Request.Parameter.front: frontImageID,
            Request.Parameter.back: backImageID,
            Request.Parameter.line1: line1,
            Request.Parameter.line2: line2,
            Request.Parameter.state: stateName,
            Request.Parameter.city: cityName,
            Request.Parameter.postal_code: postlaCode,
            Request.Parameter.country: selectedCountry,
            Request.Parameter.address: txtAddress.text ?? String(),
            Request.Parameter.firstName: currentUserHost?.firstName ?? String(),
            Request.Parameter.lastName: currentUserHost?.lastName ?? String(),
            Request.Parameter.email: currentUserHost?.email ?? String(),
            Request.Parameter.dob: currentUserHost?.dob ?? String(),
            Request.Parameter.mobileNumber: currentUserHost?.mobileNo ?? String(),
            Request.Parameter.timeZone: deviceTimeZone ?? String(),
        ]
        
        print(parameter)
        RequestManager.shared.multipartImageRequest(parameter: parameter, imagesData:  [String : Data](), headers: headers , keyName: "", urlString: PreferenceManager.shared.userBaseURL + Request.Method.addAccountDetails) { (response, error) in
                        
            LoadingManager.shared.hideLoading()

            if error == nil{
                
                if let data = response {
                    
                    let status = data["code"] as? Int ?? 0
                    let msg = data["message"] as? String ?? ""
                    let jsonStudio = data["studio_detail"] as? [String: Any]
                    print(jsonStudio as Any)
                    if status == Status.Code.success {
                        
                        delay {
                            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: msg) {
                                self.pop()
                            }
                        }
                        
                    }else if status == Status.Code.stripeIssue{
                        
                        delay {
                            
                            DisplayAlertManager.shared.displayAlert(animated: true, message: data["message"] as? String ?? "", handlerOK: nil)
                            
                        }
                    } else {
                        
                        delay {
                            
                            DisplayAlertManager.shared.displayAlert(animated: true, message: data["message"] as? String ?? "", handlerOK: nil)
                            
                        }
                        
                    }
                }
            } else{
                
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

   
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnSubmit(_ sender: Any) {
        if validate() == false {
            return
        }
        
        LoadingManager.shared.showLoading()
        
        self.performAddGolfClub { (flag : Bool) in
            
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
        
        if textField == txtAddress {
            self.view.endEditing(true)
            let controller = NavigationManager.shared.locationSearchVC
            controller.delegate = self
            let nvc = UINavigationController(rootViewController: controller)
            self.present(nvc, animated: true) {
            }
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
            LoadingManager.shared.showLoading()
            delay {
                self.performFrontImgDocument(selectedImg: image ?? UIImage())
            }
        }else if tagValue == 1{
            LoadingManager.shared.showLoading()
            delay {
                self.performBackImgDocument(selectedImg: image ?? UIImage())
            }
        }
        if let imageData = image?.jpegData(compressionQuality: 0), let compressImage = UIImage(data: imageData) {
            self.selectedImage = Toucan.init(image: compressImage).image

        }
    }
    
    //------------------------------------------------------
    
    //MARK: Text field delegate
    
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
        
        if textField == accountNumberTxt {
            guard let textFieldText = accountNumberTxt.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 16
        }
        
        if textField == routingNumberTxt {
            guard let textFieldText = routingNumberTxt.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 9
        }
        
        return true
        
    }
    
    
    //------------------------------------------------------
    
    //MARK: LocationSearchDelegate
    
    func locationSearch(controller: LocationSearchVC, didSelect location: MKPlacemark) {
        self.txtAddress.text = location.name ?? String()
        let fullAddress = String(format: "%@ %@", location.name ?? String(), location.formattedAddress ?? location.name ?? String())
        let stateName = fullAddress.components(separatedBy: " ")
        //self.line2 = "\(stateName![1]) " + ("\(stateName![2]) ") + ("\(stateName![3])")
        let count = stateName.count
        let midCount = count / 2
        var index: Int = .zero
        line1.removeAll()
        line2.removeAll()
        for word in stateName {
            if index < midCount {
                line1 = line1.appending(word).appending(" ")
            } else {
                line2 = line2.appending(word).appending(" ")
            }
            index = index + 1
        }
        self.stateName = location.administrativeArea ?? String()
        self.cityName = location.locality ?? String()
        self.postlaCode = location.postalCode ?? String()
        self.lat = "\(location.coordinate.latitude)"
        self.long = "\(location.coordinate.longitude)"
        let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude )
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, err) in
            if let placemark = placemarks?[0] {
                self.selectedTimeZone = "\(String(describing: placemark.timeZone))"
                self.selectedCountry = (String(describing: placemark.isoCountryCode ?? String()))
            }
        }
        if IQKeyboardManager.shared.canGoNext {
            IQKeyboardManager.shared.goNext()
        }
        navigationController?.popToViewController(self, animated: true)
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
