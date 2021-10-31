//
//  HomeListingDetailsVC.swift
//  Fringe
//
//  Created by MyMac on 9/9/21.
//
import UIKit
import Toucan
import SDWebImage
import Foundation
import Alamofire

class HomeListingDetailsVC : BaseVC {
    
    @IBOutlet weak var lblDetails: FGRegularLabel!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var lblPrice: FGSemiboldLabel!
    @IBOutlet weak var lblRating: FGRegularLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblAddress: FGMediumLabel!
    @IBOutlet weak var lblName: FGSemiboldLabel!
    @IBOutlet weak var imgMain: UIImageView!
    
    var chatRoomData : CreateRoomModal?
    var detailsData: HomeModal?
    var favUnfav: FavUnfvModal?
    var check = true
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setup() {
        lblName.text = detailsData?.golfCourseName
        lblAddress.text = detailsData?.location
        lblPrice.text = "$\(detailsData?.price ?? String())"
        lblRating.text = detailsData?.rating
        lblDetails.text = detailsData?.homeModalDescription
        ratingView.rating = Double(detailsData?.rating ?? String()) ?? 0.0
        
        //image
        imgMain.sd_addActivityIndicator()
        imgMain.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        imgMain.sd_showActivityIndicatorView()
        imgMain.image = getPlaceholderImage()
        if detailsData?.golfImages?.count ?? 0 > 0{
            if let image = detailsData?.golfImages?[0], image.isEmpty == false {
                let imgURL = URL(string: image)
                imgMain.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                    if let serverImage = serverImage {
                        self.imgMain.image = Toucan.init(image: serverImage).resizeByCropping(FGSettings.profileImageSize).maskWithRoundedRect(cornerRadius: 0, borderWidth: FGSettings.profileBorderWidth, borderColor: .clear).image
                    }
                    self.imgMain.sd_removeActivityIndicator()
                }
            } else {
                self.imgMain.sd_removeActivityIndicator()
            }
        } else {
            self.imgMain.sd_removeActivityIndicator()
            imgMain.image = UIImage(named: FGImageName.imgPlaceHolder)
        }

        if detailsData?.isFav == "1" {
            self.btnFav.setImage(UIImage(named: FGImageName.iconWhiteHeart), for: .normal)
        }else{
            self.btnFav.setImage(UIImage(named: FGImageName.iconUnFavWhiteHeart), for: .normal)
        }
    }
    
    func performFavUnfavStudio(completion:((_ flag: Bool) -> Void)?) {

        let headers:HTTPHeaders = [
           "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
          ]

        let parameter: [String: Any] = [
            Request.Parameter.golfID: detailsData?.golfID ?? String(),
        ]

        RequestManager.shared.requestPOST(requestMethod: Request.Method.favUnfav, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<FavUnfvModal>.self, successBlock: { (response: ResponseModal<FavUnfvModal>) in
            print(response)

            LoadingManager.shared.hideLoading()

            if response.code == Status.Code.success {

                if let stringUser = try? response.data?.jsonString() {
                    print(stringUser)
                    self.favUnfav = response.data
                    DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: response.message ?? "") {
                    }
                    if self.favUnfav?.isFav == "1"{
                        self.btnFav.setImage(UIImage(named: FGImageName.iconWhiteHeart), for: .normal)
                    }else{
                        self.btnFav.setImage(UIImage(named: FGImageName.iconUnFavWhiteHeart), for: .normal)
                    }
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
                    NavigationManager.shared.setupSingIn()
                }
            }

        })
    }
    
    func performCreateRoom(completion:((_ flag: Bool) -> Void)?) {

        let headers:HTTPHeaders = [
           "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
          ]

        let parameter: [String: Any] = [
            Request.Parameter.hostID: detailsData?.golfID ?? String(),
        ]

        RequestManager.shared.requestPOST(requestMethod: Request.Method.createRoomForChat, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<CreateRoomModal>.self, successBlock: { (response: ResponseModal<CreateRoomModal>) in
            print(response)

            LoadingManager.shared.hideLoading()

            if response.code == Status.Code.success {

                self.chatRoomData = response.data
                
                delay {
                    let controller = NavigationManager.shared.messageListingVC
                    controller.roomID = self.chatRoomData?.roomID ?? String()
                    controller.otherUserName = self.chatRoomData?.name ?? String()
                    controller.otherUserImg = self.chatRoomData?.image ?? String()
                    self.push(controller: controller)
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
                    NavigationManager.shared.setupSingIn()
                }
            }
        })
    }

    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnFavUnFav(_ sender: Any) {
        
        performFavUnfavStudio { (flag : Bool) in
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        PreferenceManager.shared.comesFromHomeListing = true
        NavigationManager.shared.setupLandingOnHome()
    }
    
    @IBAction func btnRequest(_ sender: Any) {
        
        let controller = NavigationManager.shared.checkAvailabilityVC
        controller.golfDetails = detailsData
        push(controller: controller)
    }
    
    @IBAction func btnChat(_ sender: Any) {
        performCreateRoom { (flag : Bool) in
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
    
    //------------------------------------------------------
}
