//
//  SignUpHostVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 24/08/21.
//

import UIKit
import MapKit
import Toucan
import MapKit
import Alamofire
import Foundation
import GCCountryPicker
import IQKeyboardManagerSwift

class SignUpHostVC : BaseVC, UICollectionViewDelegate , UICollectionViewDataSource, UITextFieldDelegate & UITextViewDelegate , ImagePickerDelegate, LocationSearchDelegate {
    
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
    
    private func performAddGolfCourse(completion:((_ flag: Bool) -> Void)?) {
        
        let imageData = selectedImage?.jpegData(compressionQuality: 0.2)
        var imgData = [String : Data]()
        imgData["profile_image"] = imageData
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
           ]
        let parameter: [String: Any] = [
            Request.Parameter.golfName: golfNameTxtFld.text ?? String(),
            Request.Parameter.price: golfPriceTxtFld.text ?? String(),
            Request.Parameter.location: golfAddressTxtFld.text ?? String(),
            Request.Parameter.description: golfDescriptionTxtView.text ?? String(),
        ]
        var imgDataa = [String : Data]()
        for i in photosInTheCellNow {
            let imgData = i?.jpegData(compressionQuality: 0.2)
            imgDataa["\(Date().timeIntervalSince1970)"] = imgData
        }
        
        RequestManager.shared.multipartImageRequest(parameter: parameter, imagesData: imgDataa, headers: headers, profileImagesData: imgData, keyName: "golf_images[]", profileKeyName: "image", urlString: PreferenceManager.shared.userBaseURL + Request.Method.signUpAsHost) { (response, error) in
      
            LoadingManager.shared.hideLoading()

            if error == nil{
                
                if let data = response {
                    
                    let status = data["code"] as? Int ?? 0
                    let jsonStudio = data["data"] as? [String: Any]
                    if status == Status.Code.success {
                        
//                        delay {
//
//                            PreferenceManager.shared.currentStudioUser = jsonStudio?.dict2json()
//                            let controller = NavigationManager.shared.submitVC
//                            controller.modalPresentationStyle = .overFullScreen
//                            self.present(controller, animated: false) {
//
//                            }
//                        }
                        
//                    } else if status == Status.Code.stripeIssue{
//
//                        delay {
//
//                            DisplayAlertManager.shared.displayAlert(animated: true, message: data["message"] as? String ?? "", handlerOK: nil)
//
//                        }
                    }
                    else {
                        
                        delay {
                            
                            DisplayAlertManager.shared.displayAlert(animated: true, message: data["message"] as? String ?? "", handlerOK: nil)
                            
                        }
                        
                    }
                }
            } else{
                
                delay {
                    
                    DisplayAlertManager.shared.displayAlert(animated: true, message: error?.localizedDescription ?? String())

                }
                print(error?.localizedDescription ?? String())
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
        
        performAddGolfCourse { (flag : Bool) in
            
        }
    }
    
    @IBAction func btnUploadImg(_ sender: UIButton) {
        self.imagePickerVC?.present(from: sender)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    //------------------------------------------------------
    
    //MARK: FGImagePickerDelegate
    
    func didSelect(image: UIImage?) {
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
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == golfAddressTxtFld {
            self.view.endEditing(true)
            let controller = NavigationManager.shared.locationSearchVC
            controller.delegate = self
            push(controller: controller)
            return false
        }
        return true
    }
    
    //------------------------------------------------------
    
    //MARK: LocationSearchDelegate
    
    func locationSearch(controller: LocationSearchVC, didSelect location: MKPlacemark) {
        self.golfAddressTxtFld.text = location.name ?? String()
//        self.countyCode = location.countryCode ?? String()
//        let fullAddress = String(format: "%@ %@", location.name ?? String(), location.formattedAddress ?? location.name ?? String())
//        let stateName = fullAddress.components(separatedBy: " ")
//        //self.line2 = "\(stateName![1]) " + ("\(stateName![2]) ") + ("\(stateName![3])")
//        let count = stateName.count
//        let midCount = count / 2
//        var index: Int = .zero
//        line1.removeAll()
//        line2.removeAll()
//        for word in stateName {
//            if index < midCount {
//                line1 = line1.appending(word).appending(" ")
//            } else {
//                line2 = line2.appending(word).appending(" ")
//            }
//            index = index + 1
//        }
//        self.stateName = location.administrativeArea ?? String()
//        self.cityName = location.locality ?? String()
//        self.postlaCode = location.postalCode ?? String()
//        self.lat = "\(location.coordinate.latitude)"
//        self.long = "\(location.coordinate.longitude)"
//        let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude )
//        let geoCoder = CLGeocoder()
//        geoCoder.reverseGeocodeLocation(location) { (placemarks, err) in
//            if let placemark = placemarks?[0] {
//                self.selectedTimeZone = "\(String(describing: placemark.timeZone))"
//                self.selectedCountry = "\(String(describing: placemark.isoCountryCode))"
//            }
//        }
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
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resignFirstResponder()
        NavigationManager.shared.isEnabledBottomMenu = false
    }
    
    //------------------------------------------------------
}
