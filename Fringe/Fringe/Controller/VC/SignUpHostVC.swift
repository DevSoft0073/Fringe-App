//
//  SignUpHostVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 24/08/21.
//

import UIKit
import Foundation
import Toucan
import IQKeyboardManagerSwift
import MapKit
import GCCountryPicker

class SignUpHostVC : BaseVC, UICollectionViewDelegate , UICollectionViewDataSource, UITextFieldDelegate & UITextViewDelegate , FGImagePickerDelegate {
    
    
    @IBOutlet weak var golfDescriptionTxtView: FGRegularWithoutBorderTextView!
    @IBOutlet weak var golfPriceTxtFld: FGGolfCreditsTextField!
    @IBOutlet weak var golfAddressTxtFld: FGGolfAddressTextField!
    @IBOutlet weak var golfNameTxtFld: FGGolfCourseNameTextField!
    @IBOutlet weak var uploadImageCollectionView: UICollectionView!
    @IBOutlet weak var profileImg: UIImageView!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var countryCode = String()
    var lat = String()
    var long = String()
    var countyCode = String()
    var stateName = String()
    var cityName = String()
    var postlaCode = String()
    var line1 = String()
    var line2 = String()
    var showImage = ["sign_plus"]
    var textTitle: String?
//    var locations = [Location]()
    var studioProfileParameter: [String: Any] = [:]
    var photosInTheCellNow = [UIImage?]()
    var imagePickerVC: ImagePicker?
    var selectedImage: UIImage? {
        didSet {
            if selectedImage != nil {
                photosInTheCellNow.append(selectedImage)
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
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
       
        golfNameTxtFld.delegate = self
        golfAddressTxtFld.delegate = self
        golfPriceTxtFld.delegate = self
        golfDescriptionTxtView.delegate = self
        uploadImageCollectionView.dataSource  = self
        uploadImageCollectionView.delegate = self
        title = textTitle
        
        imagePickerVC = ImagePicker(presentationController: self, delegate: self)
        
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: golfNameTxtFld.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterGolfCourseName) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: golfAddressTxtFld.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterGolfCourseAddress) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: golfPriceTxtFld.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterGolfCoursePrice) {
            }
            return false
        }
        
       
        
        
        if ValidationManager.shared.isEmpty(text: golfDescriptionTxtView.text) == true {
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.ValidationMessage.enterGolfCourseDescription) {
            }
            return false
        }
        
        
        return true
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnSubmit(_ sender: Any) {
        if validate() == false {
            return
        }
    }
    
    @IBAction func btnUploadImg(_ sender: Any) {
//        selectedImage()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    
    //------------------------------------------------------
    
    //MARK: FGImagePickerDelegate
    
    
    func didSelect(controller: ImagePicker, image: UIImage?) {
        if let imageData = image?.jpegData(compressionQuality: 0), let compressImage = UIImage(data: imageData) {
            self.selectedImage = Toucan.init(image: compressImage).image
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GolfProfileAddImagesCell", for: indexPath) as! GolfProfileAddImagesCell
        
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
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resignFirstResponder()
        NavigationManager.shared.isEnabledBottomMenu = false
    }
    
    //------------------------------------------------------
}
