//
//  HostEditProfileVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 31/08/21.
//

import UIKit
import Toucan
import MapKit
import Alamofire
import SDWebImage
import Foundation
import CoreLocation
import SKCountryPicker
import IQKeyboardManagerSwift

class HostEditProfileVC : BaseVC, UITextFieldDelegate, UITextViewDelegate,  ImagePickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, LocationSearchDelegate {
    
    
    @IBOutlet weak var txtHandicap: FGEmailTextField!
    @IBOutlet weak var txtMemberCourse: FGEmailTextField!
    @IBOutlet weak var txtProfession: FGEmailTextField!
    @IBOutlet weak var countryCode: FGSemiboldButton!
    @IBOutlet weak var uploadImageCollectionView: UICollectionView!
    @IBOutlet weak var txtMobileNumber: FGMobileNumberTextField!
    @IBOutlet weak var txtEmail: FGEmailTextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFirstName: FGUsernameTextField!
    @IBOutlet weak var txtAddress: FGAddressTextField!
    
    var countryCodes = String()
    var checkPickerVal = Bool()
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var imagePickerVC: ImagePicker?
    var showImage = ["sign_plus"]
    var photosInTheCellNow = [UIImage?]()
    var textTitle: String?
    var selectedImage: UIImage? {
        didSet {
            if selectedImage != nil {
                imgProfile.image = selectedImage
            }
        }
    }
    
    var selectedImageForClub: UIImage? {
        didSet {
            if selectedImageForClub != nil {
                //                imgProfile.image = selectedImageForClub
                photosInTheCellNow.append(selectedImageForClub)
                uploadImageCollectionView.reloadData()
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
        txtAddress.delegate = self
        txtEmail.delegate = self
        txtMobileNumber.delegate = self
        
        uploadImageCollectionView.delegate = self
        uploadImageCollectionView.dataSource = self
        txtEmail.isUserInteractionEnabled = false
        self.countryCode.contentHorizontalAlignment = .center
        guard let country = CountryManager.shared.currentCountry else {
            return
        }
        countryCode.setTitle(country.countryCode, for: .highlighted)
        countryCode.clipsToBounds = true
        
        if currentUserHost?.countryCode == "" {
            countryCode.setTitle("+1", for: .normal)
        } else {
            countryCode.setTitle(currentUserHost?.countryCode, for: .normal)
        }
    }
    
    func setupData() {
        
        //image
        imgProfile.sd_addActivityIndicator()
        imgProfile.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        imgProfile.sd_showActivityIndicatorView()
        if let image = currentUserHost?.image, image.isEmpty == false {
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
        txtFirstName.text = currentUserHost?.golfCourseName

        //email
        txtEmail.text = currentUserHost?.email
        
        //genres
        txtAddress.text = currentUserHost?.location
        
        //phone
        txtMobileNumber.text = currentUserHost?.mobileNo
        
        // country code
        countryCode.setTitle(currentUserHost?.countryCode, for: .normal)
        
        //profession
        txtProfession.text = currentUserHost?.profession
        
        //member course
        txtMemberCourse.text = currentUserHost?.memberCourse
        
        //handicap
        txtHandicap.text = currentUserHost?.golfHandicap
        
        //Show images
        
        DispatchQueue.global(qos: .background).async {
            print(self.currentUserHost?.golfImages)
            for i in self.currentUserHost?.golfImages ?? [] {
                let image = i
                var imgArray = [String]()
                imgArray.removeAll()
                if image != ""{imgArray.append(image)}
                for img in imgArray{
                    let imageUrl = URL(string: img)
                    if let data = try? Data(contentsOf: imageUrl ?? URL(fileURLWithPath: ""))
                    {
                        let image: UIImage = UIImage(data: data)!
                        self.photosInTheCellNow.append(image)
                    }
                }
                DispatchQueue.main.async {
                    self.uploadImageCollectionView.reloadData()
                }
            }
        }
    }
    
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtFirstName.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterFirstName) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtAddress.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.selectAddress) {
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
    
    private func performEditStudio() {
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        let imageData = selectedImage?.jpegData(compressionQuality: 0.2)
        var imgData = [String : Data]()
        imgData["image"] = imageData
        let parameter: [String: Any] = [
            Request.Parameter.golfName: txtFirstName?.text ?? String(),
            Request.Parameter.location: txtAddress.text ?? String(),
            Request.Parameter.mobileNumber: txtMobileNumber.text ?? String(),
            Request.Parameter.userID: PreferenceManager.shared.userId ?? String(),
            Request.Parameter.countryCode: countryCodes ,
            Request.Parameter.profession: txtProfession.text ?? String(),
            Request.Parameter.memberCourse: txtMemberCourse.text ?? String(),
            Request.Parameter.golfHandicap: txtHandicap.text ?? String(),
        ]
        var imgDataa = [String : Data]()
        for i in photosInTheCellNow {
            let imgData = i?.jpegData(compressionQuality: 0.2)
            imgDataa["\(Date().timeIntervalSince1970)"] = imgData
        }
        
        RequestManager.shared.multipartImageRequest(parameter: parameter, imagesData: imgDataa, headers: headers, profileImagesData: imgData, keyName: "golf_images[]", profileKeyName: "image", urlString: PreferenceManager.shared.userBaseURL + Request.Method.editHostProfile) { (response, error) in
            
            if error == nil{
                
                if let data = response {
                    
                    LoadingManager.shared.hideLoading()
                    
                    let status = data["code"] as? Int ?? 0
//                    let data = data["data"] as? [String: Any]
//                    PreferenceManager.shared.currentUserHost = data?.dict2json()
                    if status == Status.Code.success {
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
    
    func performGetUserProfile() {
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.hostProfile, parameter: [:], headers: headers, showLoader: false, decodingType: ResponseModal<HostModal>.self, successBlock: { (response: ResponseModal<HostModal>) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                
                if let stringUser = try? response.data?.jsonString() {
                    
                    PreferenceManager.shared.currentUserHost = stringUser
                    self.setupData()
                }
                                
            } else {
                
                delay {
                    
                    
                }
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            delay {
                
                DisplayAlertManager.shared.displayAlert(target: self, animated: false, message: LocalizableConstants.Error.anotherLogin) {
                    PreferenceManager.shared.userId = nil
                    PreferenceManager.shared.currentUser = nil
                    PreferenceManager.shared.authToken = nil
                    PreferenceManager.shared.curretMode = "1"
                    NavigationManager.shared.setupSingIn()
                }
            }
            
        })
    }

    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnProfileImg(_ sender: Any) {
        checkPickerVal = true
        self.imagePickerVC?.present(from: (sender as? UIView)!)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if validate() == false {
            return
        }
        self.view.endEditing(true)
        
        LoadingManager.shared.showLoading()
        
        delay {
            self.performEditStudio()
        }
    }
    
    @IBAction func btnOpenCountry(_ sender: Any) {
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
            
            if checkPickerVal == true {
                self.selectedImage = Toucan.init(image: compressImage).resizeByCropping(FGSettings.profileImageSize).maskWithRoundedRect(cornerRadius: FGSettings.profileImageSize.width/2, borderWidth: FGSettings.profileBorderWidth, borderColor: FGColor.appGreen).image
                imgProfile.image = selectedImage
            }else{
                self.selectedImageForClub = Toucan.init(image: compressImage).image
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Collection View Delegate Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photosInTheCellNow.count == 0{
            return showImage.count
        }else{
            return photosInTheCellNow.count+1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HostProfileAddImageCell", for: indexPath) as! HostProfileAddImageCell
        
        if indexPath.row == 0{
            cell.addImage.image = UIImage(named: showImage[indexPath.row])
            cell.btnDelete.isHidden = true
        }else{
            cell.addImage.image =  photosInTheCellNow[indexPath.row-1]
            cell.btnDelete.isHidden = false
            cell.btnDelete.tag = indexPath.row-1
            cell.btnDelete.addTarget(self, action: #selector(deleteAddedImages(sender:)), for: .touchUpInside)
        }
        return cell
    }
    
    @objc func deleteAddedImages(sender : UIButton) {
        let dltImg = sender.tag
        photosInTheCellNow.remove(at: dltImg)
        uploadImageCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if photosInTheCellNow.count >= 5 {
            DisplayAlertManager.shared.displayAlert(animated: true, message: LocalizableConstants.Error.maximumLimit)
        }else{
            checkPickerVal = false
            self.imagePickerVC?.present(from: view)
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
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
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
    
    //------------------------------------------------------
    
    //MARK: LocationSearchDelegate
    
    func locationSearch(controller: LocationSearchVC, didSelect location: MKPlacemark) {
        self.txtAddress.text = location.name ?? String()
        if IQKeyboardManager.shared.canGoNext {
            IQKeyboardManager.shared.goNext()
        }
        navigationController?.popToViewController(self, animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationManager.shared.isEnabledBottomMenuForHost = false
        performGetUserProfile()
        setup()
      //  setupData()
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgProfile.circle()
    }
    
    //------------------------------------------------------
}
