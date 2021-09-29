//
//  DetailsScreenVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 23/08/21.
//
import UIKit
import Toucan
import Alamofire
import SDWebImage
import Foundation

class DetailsScreenVC : BaseVC {
    
    @IBOutlet weak var imgGolfClub: UIImageView!
    @IBOutlet weak var lblDetails: FGRegularLabel!
    @IBOutlet weak var lblRate: FGSemiboldLabel!
    @IBOutlet weak var lblRating: FGRegularLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblGolfClubAddress: FGMediumLabel!
    @IBOutlet weak var lblGolfClubName: FGSemiboldLabel!
    @IBOutlet weak var btnHeart: UIButton!
    
    var isUpdateTBView:(()->Void)?
    var golfCourseDetails: FavoriteListing?
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
        lblRate.text = golfCourseDetails?.price
        lblRating.text = golfCourseDetails?.rating
        lblGolfClubAddress.text = golfCourseDetails?.location
        lblGolfClubName.text = golfCourseDetails?.golfCourseName
        lblDetails.text = golfCourseDetails?.favoriteListingDescription
        ratingView.rating = Double(golfCourseDetails?.rating ?? String()) ?? 0.0
        
        imgGolfClub.sd_addActivityIndicator()
        imgGolfClub.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        imgGolfClub.sd_showActivityIndicatorView()
        if golfCourseDetails?.golfImages?.count ?? 0 > 0 {
            if let image = golfCourseDetails?.golfImages?[0], image.isEmpty == false {
                let imgURL = URL(string: image)
                imgGolfClub.sd_setImage(with: imgURL) { ( serverImage: UIImage?, _: Error?, _: SDImageCacheType, _: URL?) in
                    if let serverImage = serverImage {
                        self.imgGolfClub.image = Toucan.init(image: serverImage).resizeByCropping(FGSettings.profileImageSize).maskWithRoundedRect(cornerRadius: 0, borderWidth: FGSettings.profileBorderWidth, borderColor: .clear).image
                    }
                    self.imgGolfClub.sd_removeActivityIndicator()
                }
            } else {
                self.imgGolfClub.sd_removeActivityIndicator()
            }
        } else {
            self.imgGolfClub.sd_removeActivityIndicator()
            imgGolfClub.image = UIImage(named: FGImageName.imgPlaceHolder)
        }
   
        if golfCourseDetails?.isFav == "1" {
            self.btnHeart.setImage(UIImage(named: FGImageName.iconWhiteHeart), for: .normal)
        }else{
            self.btnHeart.setImage(UIImage(named: FGImageName.iconUnFavWhiteHeart), for: .normal)
        }
    }    
    
    func performFavUnfavStudio(completion:((_ flag: Bool) -> Void)?) {

        let headers:HTTPHeaders = [
           "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
          ]

        let parameter: [String: Any] = [
            Request.Parameter.golfID: golfCourseDetails?.golfID ?? String(),
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
                        self.btnHeart.setImage(UIImage(named: FGImageName.iconWhiteHeart), for: .normal)
                    }else{
                        self.btnHeart.setImage(UIImage(named: FGImageName.iconUnFavWhiteHeart), for: .normal)
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
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnHeart(_ sender: Any) {
        performFavUnfavStudio { (flag : Bool) in
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.isUpdateTBView?()
        self.pop()
    }
    
    @IBAction func btnChat(_ sender: Any) {
    }
    
    @IBAction func btnCheckAvailability(_ sender: Any) {
        let controller = NavigationManager.shared.checkAvailabilityVC
        controller.golfId = golfCourseDetails?.golfID ?? String()
        push(controller: controller)
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
    
    //------------------------------------------------------
}
