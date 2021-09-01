//
//  HostEditProfileVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 31/08/21.
//

import UIKit
import Foundation
import Toucan
import SDWebImage
import IQKeyboardManagerSwift

class HostEditProfileVC : BaseVC, UITextFieldDelegate, UITextViewDelegate,  ImagePickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var uploadImageCollectionView: UICollectionView!
    @IBOutlet weak var txtMobileNumber: FGMobileNumberTextField!
    @IBOutlet weak var txtEmail: FGEmailTextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFirstName: FGUsernameTextField!
    @IBOutlet weak var txtLastName: FGUsernameTextField!
    @IBOutlet weak var txtBirthDate: FGBirthDateTextField!
    @IBOutlet weak var txtAddress: FGAddressTextField!
    
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
//                photosInTheCellNow.append(selectedImage)
//                uploadImageCollectionView.reloadData()
            }
        }
    }
    
    var selectedImageForClub: UIImage? {
        didSet {
            if selectedImageForClub != nil {
                imgProfile.image = selectedImageForClub
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
        txtLastName.delegate = self
        txtBirthDate.delegate = self
        txtAddress.delegate = self
        txtEmail.delegate = self
        txtMobileNumber.delegate = self
        
        uploadImageCollectionView.delegate = self
        uploadImageCollectionView.dataSource = self
        
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
        if photosInTheCellNow.count >= 10 {
            //            DisplayAlertManager.shared.displayAlert(message: LocalizableConstants.Error.maximumLimit)
        }else{
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
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
